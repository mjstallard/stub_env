shared_examples 'stub_env tests' do
  before :each do
    ENV['UNSTUBBED'] = 'unstubbed'
  end

  describe '#[]' do
    context 'with a single stubbed variable' do
      before :each do
        stub_env('TEST', 'success')
      end
      it 'stubs out environment variables' do
        expect(ENV['TEST']).to eq 'success'
      end

      it 'leaves original environment variables unstubbed' do
        expect(ENV['UNSTUBBED']).to eq 'unstubbed'
      end
    end

    context 'with multiple stubbed variables' do
      before :each do
        stub_env('TEST', 'success')
        stub_env('TEST2', 'another success')
      end

      it 'stubs out the first variable' do
        expect(ENV['TEST']).to eq 'success'
      end

      it 'stubs out the second variable' do
        expect(ENV['TEST2']).to eq 'another success'
      end

      it 'leaves original environment variables unstubbed' do
        expect(ENV['UNSTUBBED']).to eq 'unstubbed'
      end
    end

    context 'with multiple stubbed variables in a hash' do
      before :each do
        stub_env({'TEST' => 'success', 'TEST2' => 'another success'})
      end

      it 'stubs out the first variable' do
        expect(ENV['TEST']).to eq 'success'
      end

      it 'stubs out the second variable' do
        expect(ENV['TEST2']).to eq 'another success'
      end

      it 'leaves original environment variables unstubbed' do
        expect(ENV['UNSTUBBED']).to eq 'unstubbed'
      end
    end

    context 'with existing environment variables' do
      before :each do
        ENV['TO_OVERWRITE'] = 'to overwrite'
      end

      it 'returns the original value' do
        expect(ENV['TO_OVERWRITE']).to eq 'to overwrite'
      end

      it 'allows the original value to be stubbed' do
        stub_env('TO_OVERWRITE', 'overwritten')
        expect(ENV['TO_OVERWRITE']).to eq 'overwritten'
      end

      it 'allows the original value to be stubbed with nil' do
        stub_env('TO_OVERWRITE', nil)
        expect(ENV['TO_OVERWRITE']).to be_nil
      end
    end
  end

  describe '#fetch' do
    context 'with a single stubbed variable' do
      before :each do
        stub_env('TEST', 'success')
      end
      it 'stubs out environment variables' do
        expect(ENV.fetch('TEST')).to eq 'success'
      end

      it 'leaves original environment variables unstubbed' do
        expect(ENV.fetch('UNSTUBBED')).to eq 'unstubbed'
      end
    end

    context 'with multiple stubbed variables' do
      before :each do
        stub_env('TEST', 'success')
        stub_env('TEST2', 'another success')
      end

      it 'stubs out the first variable' do
        expect(ENV.fetch('TEST')).to eq 'success'
      end

      it 'stubs out the second variable' do
        expect(ENV.fetch('TEST2')).to eq 'another success'
      end

      it 'leaves original environment variables unstubbed' do
        expect(ENV.fetch('UNSTUBBED')).to eq 'unstubbed'
      end
    end

    context 'with multiple stubbed variables in a hash' do
      before :each do
        stub_env({'TEST' => 'success', 'TEST2' => 'another success'})
      end

      it 'stubs out the first variable' do
        expect(ENV.fetch('TEST')).to eq 'success'
      end

      it 'stubs out the second variable' do
        expect(ENV.fetch('TEST2')).to eq 'another success'
      end

      it 'leaves original environment variables unstubbed' do
        expect(ENV.fetch('UNSTUBBED')).to eq 'unstubbed'
      end
    end

    context 'with existing environment variables' do
      before :each do
        ENV['TO_OVERWRITE'] = 'to overwrite'
      end

      it 'returns the original value' do
        expect(ENV.fetch('TO_OVERWRITE')).to eq 'to overwrite'
      end

      context 'stubbed with a value' do
        it 'allows the original value to be stubbed' do
          stub_env('TO_OVERWRITE', 'overwritten')
          expect(ENV.fetch('TO_OVERWRITE')).to eq 'overwritten'
        end

        it 'returns the stubbed value even if a default is specified' do
          stub_env('TO_OVERWRITE', 'overwritten')
          expect(ENV.fetch('TO_OVERWRITE', 'DEFAULT')).to eq 'overwritten'
        end
      end

      context 'stubbed with nil' do
        before :each do
          stub_env('TO_OVERWRITE', nil)
        end

        it 'returns nil' do
          expect(ENV.fetch('TO_OVERWRITE')).to be_nil
        end

        it 'returns the default if specified' do
          expect(ENV.fetch('TO_OVERWRITE', 'DEFAULT')).to eq 'DEFAULT'
        end
      end
    end
  end

  describe '#key?' do
    context 'with a single stubbed variable' do
      let(:value) { 'success' }
      before :each do
        stub_env('TEST', value)
      end

      it 'stubs out environment variables' do
        expect(ENV.key?('TEST')).to be(true)
      end

      it 'leaves original environment variables unstubbed' do
        expect(ENV.key?('UNSTUBBED')).to be(true)
      end

      it 'returns false for missing values' do
        expect(ENV.key?('DOES_NOT_EXIST')).to be(false)
      end

      context 'when stubbed with an empty string' do
        let(:value) { '' }
        it 'returns true' do
          expect(ENV.key?('TEST')).to be(true)
        end
      end

      context 'when stubbed with nil' do
        let(:value) { nil }
        it 'returns false' do
          expect(ENV.key?('TEST')).to be(false)
        end
      end
    end

    context 'with multiple stubbed variables' do
      before :each do
        stub_env('TEST', 'success')
        stub_env('TEST2', 'another success')
        stub_env('TEST_EMPTY_STRING', '')
        stub_env('TEST_NIL', nil)
      end

      it 'stubs out the first variable' do
        expect(ENV.key?('TEST')).to be(true)
      end

      it 'stubs out the second variable' do
        expect(ENV.key?('TEST2')).to be(true)
      end

      it 'returns true for an empty string value' do
        expect(ENV.key?('TEST_EMPTY_STRING')).to be(true)
      end

      it 'returns false for a nil value' do
        expect(ENV.key?('TEST_NIL')).to be(false)
      end

      it 'leaves original environment variables unstubbed' do
        expect(ENV.key?('UNSTUBBED')).to be(true)
      end

      it 'returns false for missing values' do
        expect(ENV.key?('DOES_NOT_EXIST')).to be(false)
      end
    end

    context 'with multiple stubbed variables in a hash' do
      before :each do
        stub_env({'TEST' => 'success', 'TEST2' => 'another success'})
      end

      it 'stubs out the first variable' do
        expect(ENV.key?('TEST')).to be(true)
      end

      it 'stubs out the second variable' do
        expect(ENV.key?('TEST2')).to be(true)
      end

      it 'leaves original environment variables unstubbed' do
        expect(ENV.key?('UNSTUBBED')).to be(true)
      end

      it 'returns false for missing values' do
        expect(ENV.key?('DOES_NOT_EXIST')).to be(false)
      end
    end

    context 'with existing environment variables' do
      before :each do
        ENV['TO_OVERWRITE'] = 'to overwrite'
      end

      it 'returns the original value' do
        expect(ENV.key?('TO_OVERWRITE')).to be(true)
      end

      it 'returns false for missing values' do
        expect(ENV.key?('DOES_NOT_EXIST')).to be(false)
      end

      context 'stubbed with a value' do
        it 'allows the original value to be stubbed' do
          stub_env('TO_OVERWRITE', 'overwritten')
          expect(ENV.key?('TO_OVERWRITE')).to be(true)
        end
      end

      context 'stubbed with nil' do
        before :each do
          stub_env('TO_OVERWRITE', nil)
        end

        it 'returns false' do
          expect(ENV.key?('TO_OVERWRITE')).to be(false)
        end
      end

      context 'stubbed with an empty string' do
        before :each do
          stub_env('TO_OVERWRITE', '')
        end

        it 'returns true' do
          expect(ENV.key?('TO_OVERWRITE')).to be(true)
        end
      end
    end
  end

  describe 'keys' do
    context 'with a single stubbed variable' do
      let(:value) { 'success' }
      before :each do
        stub_env('TEST', value)
      end

      it 'includes the stubbed key in the list of keys' do
        expect(ENV.keys).to include('TEST')
      end

      it 'includes original environment variable keys in the list of keys' do
        expect(ENV.keys).to include('UNSTUBBED')
      end

      context 'when stubbed with an empty string' do
        let(:value) { '' }
        it 'includes the stubbed key in the list of keys' do
          expect(ENV.keys).to include('TEST')
        end
      end

      context 'when stubbed with nil' do
        let(:value) { nil }
        it 'does not include the stubbed key in the list of keys' do
          expect(ENV.keys).not_to include('TEST')
        end
      end
    end

    context 'with multiple stubbed variables' do
      before :each do
        stub_env('TEST', 'success')
        stub_env('TEST2', 'another success')
        stub_env('TEST_EMPTY_STRING', '')
        stub_env('TEST_NIL', nil)
      end

      it 'includes the first variable name in the list of keys' do
        expect(ENV.keys).to include('TEST')
      end

      it 'includes the second variable name in the list of keys' do
        expect(ENV.keys).to include('TEST2')
      end

      it 'includes a variable with an empty string in the list of keys' do
        expect(ENV.keys).to include('TEST_EMPTY_STRING')
      end

      it 'does not include variables with a nil value in the list of keys' do
        expect(ENV.keys).not_to include('TEST_NIL')
      end

      it 'includes original environment variables in the list of keys' do
        expect(ENV.keys).to include('UNSTUBBED')
      end

      it 'does not include keys that are not in the environment' do
        expect(ENV.keys).not_to include('DOES_NOT_EXIST')
      end
    end

    context 'with multiple stubbed variables in a hash' do
      before :each do
        stub_env({'TEST' => 'success', 'TEST2' => 'another success'})
      end

      it 'includes the first variable name in the list of keys' do
        expect(ENV.keys).to include('TEST')
      end

      it 'includes the second variable name in the list of keys' do
        expect(ENV.keys).to include('TEST2')
      end

      it 'includes original environment variables in the list of keys' do
        expect(ENV.keys).to include('UNSTUBBED')
      end

      it 'does not include keys that are not in the environment' do
        expect(ENV.keys).not_to include('DOES_NOT_EXIST')
      end
    end

    context 'with existing environment variables' do
      before :each do
        ENV['TO_OVERWRITE'] = 'to overwrite'
      end

      it 'has the existing key in the list of keys' do
        expect(ENV.keys).to include('TO_OVERWRITE')
      end

      it 'does not have a non-existent key in the list of keys' do
        expect(ENV.keys).not_to include('DOES_NOT_EXIST')
      end

      context 'stubbing an existing key with a value' do
        before do
          stub_env('TO_OVERWRITE', 'overwritten')
        end

        it 'has the existing key in the list of keys' do
          expect(ENV.keys).to include('TO_OVERWRITE')
        end

        it 'only has one instance of the existing key in the list of keys' do
          matching_keys = ENV.keys.select { |k| k == 'TO_OVERWRITE' }
          expect(matching_keys.length).to eq(1)
        end
      end

      context 'stubbing an existing key with nil' do
        before :each do
          stub_env('TO_OVERWRITE', nil)
        end

        it 'does not have the key in the list of keys' do
          expect(ENV.keys).not_to include('TO_OVERWRITE')
        end
      end

      context 'stubbing an existing key with an empty string' do
        before :each do
          stub_env('TO_OVERWRITE', '')
        end

        it 'returns true' do
          expect(ENV.key?('TO_OVERWRITE')).to be(true)
        end
      end
    end
  end
end
