require "spec_helper"

RSpec.describe PrismicRails do

  PRISMIC_API_URL = 'https://prismic-rails.prismic.io/api'.freeze
  PRISMIC_REF = 'WTcXUisAACoAfW4r'.freeze

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
    before :each do
      subject.instance_variable_set('@api', nil)
    end

    context 'without internet connection' do
      it 'of the type nil' do
        stub_request(:any, PRISMIC_API_URL).to_return(body: "errors", status: 404)
        expect(subject.api).to be_nil
      end
    end

    context 'with internet connection' do
      it 'of the type Prismic::API', :vrc do
        expect(subject.api).to be_a(Prismic::API)
      end
    end

  end

  context 'has a prismic ref', :vcr do
    context 'with caching enabled' do
      before do 
        PrismicRails.configure do |config|
          config.caching = true
        end
      subject.instance_variable_set('@ref', nil)
      allow(Rails.cache).to receive(:write)
      end

      it 'gets the master ref of prismic' do
        expect(subject.ref).to be_eql(PRISMIC_REF)
      end

      it 'caching_enabled? returns true' do
        expect(subject.caching_enabled?).to be true
      end

      it 'gets the master ref of prismic out of the cache if the api is nil' do
        allow(Rails.cache).to receive(:fetch) { PRISMIC_REF }
        subject.instance_variable_set('@api', nil)
        stub_request(:any, PRISMIC_API_URL).to_return(body: "errors", status: 404)
        expect(subject.ref).to eql(PRISMIC_REF)
      end
    end

    context 'without caching enabled' do
      before :each do
        PrismicRails.configure do |config|
          config.caching = false
        end
      subject.instance_variable_set('@ref', nil)
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
