require "spec_helper"

RSpec.describe PrismicRails do

  PRISMIC_API_URL = 'https://prismic-rails.prismic.io/api'.freeze
  PRISMIC_REF = 'WoQTESsAAJIxwFWJ'.freeze

  it "has a version number" do
    expect(PrismicRails::VERSION).not_to be nil
  end

  context 'has a configuration' do
    it 'of the type PrismicRails::Config' do
      expect(subject.config).to be_a(PrismicRails::Config)
    end

    it 'yields the config block' do
      expect do |b|
        subject.configure(&b)
      end.to yield_with_args
    end

    it 'with an api url' do
      expect(PrismicRails.config.url).to eq(PRISMIC_API_URL)
    end
  end

  context 'holds an api object' do
    context 'with internet connection' do
      it 'of the type Prismic::API' do
        expect(subject.api).to be_a(Prismic::API)
      end
    end
  end

  context 'has a prismic ref' do
    context 'with caching enabled' do
      before do
        PrismicRails.configure do |config|
          config.caching = true
        end

        allow(Rails.cache).to receive(:write)
      end

      it 'gets the master ref of prismic' do
        expect(subject.ref).to be_eql(PRISMIC_REF)
      end

      it 'caching_enabled? returns true' do
        expect(subject.caching_enabled?).to be true
      end

      it 'gets the master ref of prismic out of the cache if the api is not available' do
        expect(subject).to receive(:api).and_raise(PrismicRails::NoPrismicAPIConnection)
        expect(Rails.cache).to receive(:fetch).with('prismic_rails_ref').and_return(PRISMIC_REF)
        expect(subject.get_cached_ref).to eq(PRISMIC_REF)
      end
    end

    context 'without caching enabled' do
      before :each do
        PrismicRails.configure do |config|
          config.caching = false
        end
      end

      it 'caching_enabled? returns false' do
        expect(subject.caching_enabled?).to be false
      end

      it 'gets the master ref out of the prismic api' do
        expect(subject.ref).to eql(PRISMIC_REF);
      end
    end
  end
end
