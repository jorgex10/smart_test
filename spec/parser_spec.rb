require 'spec_helper'
require_relative '../lib/parser'

describe Parser do
  subject(:service) { described_class.new(arguments) }

  let(:arguments) { nil }

  describe '#call' do
    let(:file) { 'webserver-test.log' }
    let(:content) { nil }

    context 'with empty arguments' do
      it { expect { raise StandardError }.to raise_error }
    end

    context 'with a given file' do
      let(:arguments) { ['webserver-test.log'] }

      before do
        File.open(file, 'w') { |f| f.write(content) }

        service.call
      end

      context 'with an empty content' do
        let(:content) { "" }

        it { expect(service.results).to eq({}) }
      end

      context 'with a routes without IP' do
        let(:content) { "/app" }

        it { expect(service.results).to eq({}) }
      end

      context 'with a routes with an invalid IP' do
        let(:content) { "/app 1......1" }

        it { expect(service.results).to eq({}) }
      end

      context 'with one visit to /app' do
        let(:content) { "/app 192.168.1.1" }

        it { expect(service.results).to eq({ :'/app' => 1 }) }
      end

      context 'with two visits to /app' do
        let(:content) do
          [
            ['/app', '192.168.1.1'].join(' '),
            ['/app', '192.168.1.2'].join(' ')
          ].join("\n")
        end

        it { expect(service.results).to eq({ :'/app' => 2 }) }
      end

      context 'with a couple of diferent routes' do
        let(:content) do
          [
            ['/app_one', '192.168.1.1'].join(' '),
            ['/app_two', '192.168.1.1'].join(' ')
          ].join("\n")
        end

        it { expect(service.results).to eq({ :'/app_one' => 1, :'/app_two' => 1 }) }
      end
    end
  end
end
