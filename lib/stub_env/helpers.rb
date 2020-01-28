module StubEnv
  module Helpers
    def stub_env(key_or_hash, value = nil)
      init_stub unless env_stubbed?
      if key_or_hash.is_a? Hash
        key_or_hash.each { |k, v| add_stubbed_value(k, v) }
      else
        add_stubbed_value key_or_hash, value
      end
    end

    private

    STUBBED_KEY = '__STUBBED__'
    ORIGINAL_KEYS = ENV.method(:keys)

    def add_stubbed_value(key, value)
      allow(ENV).to receive(:[]).with(key).and_return(value)
      allow(ENV).to receive(:fetch).with(key).and_return(value)
      allow(ENV).to receive(:fetch).with(key, anything()) do |_, default_val|
        value || default_val
      end
      configure_keys(key, value)
    end

    def configure_keys(key, value)
      allow(ENV).to receive(:key?).with(key).and_return(!value.nil?)

      if value.nil?
        @STUBBED_KEYS_WITH_VALUES.delete(key)
        @STUBBED_KEYS_WITH_NIL_VALUES.add(key)
      else
        @STUBBED_KEYS_WITH_VALUES.add(key)
        @STUBBED_KEYS_WITH_NIL_VALUES.delete(key)
      end
    end

    def env_stubbed?
      ENV[STUBBED_KEY]
    end

    def init_stub
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:fetch).and_call_original

      allow(ENV).to receive(:key?).and_call_original
      @STUBBED_KEYS_WITH_VALUES = Set.new
      @STUBBED_KEYS_WITH_NIL_VALUES = Set.new

      allow(ENV).to receive(:keys) do
        (Set.new(ORIGINAL_KEYS.call) | @STUBBED_KEYS_WITH_VALUES) - @STUBBED_KEYS_WITH_NIL_VALUES
      end

      add_stubbed_value(STUBBED_KEY, true)
    end
  end
end
