require 'spec_helper'

describe Api::V1::AssetsController do
  let(:user) { Fabricate(:user) }
  let(:project) { Fabricate(:project, :user => user) }
  let(:board) { Fabricate(:board, :user => user, :project => project) }

  before do
    controller.stub(:current_account => user)
  end

  describe '#index' do
    let(:asset_ids) { [] }

    subject(:api_asset) { json_to_ostruct(response.body) }

    context 'when no assets are available' do
      before { get(:index, :ids => asset_ids) }

      its('assets.size') { should eq(0) }
    end

    context 'when queried ids are available' do
      let(:card) { Fabricate(
        'card/photo', :user => user, :project => project, :board => board) }
      let(:asset_ids) { [card.image.id] }

      before { get(:index, :ids => asset_ids) }

      its('assets.size') { should eq(1) }
    end

    context 'when queried ids are not available' do
      let(:card) { Fabricate('card/photo') }
      let(:asset_ids) { [card.image.id] }

      it 'gives 404' do
        expect{ get(:index, :ids => asset_ids) }.to raise_error(
          ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#show' do
    let(:asset_id) { rand(99..999) }

    it 'gives not found when asset is not available' do
      expect {
        get(:show, :id => asset_id)
      }.to raise_error
    end

    context 'for available assets' do
      let(:card) { Fabricate(
        'card/photo', :user => user, :project => project, :board => board) }
      let(:image) { card.image }
      let(:asset_id) { image.id }
      let(:json_root) { 'image' }

      before { get(:show, :id => asset_id) }

      subject(:api_asset) { json_to_ostruct(response.body, json_root) }

      its('keys.size') { should eq(13) }
      its(:id) { should eq(image.id) }
      its(:description) { should eq(image.description) }
      its(:type) { should eq(image.type.to_s.demodulize) }
      its(:attachment) { should eq(image.attachment.url) }
      its(:user_id) { should eq(image.user.id) }
      its(:board_id) { should eq(image.board.id) }
      its(:whiteboard_id) { should eq(image.whiteboard_id) }
      its(:project_id) { should eq(image.project.id) }
      its(:assetable_type) { should eq('Card') }
      its(:assetable_id) { should eq(card.id) }
      its(:thumb_size_url) { should eq(image.attachment.url(:thumb)) }
      its(:small_size_url) { should eq(image.attachment.url(:small)) }
      its(:medium_size_url) { should eq(image.attachment.url(:medium)) }
    end
  end

  describe '#update' do
    let(:asset_id) { rand(99..999) }
    let(:attrs) { {:description => ''} }
    let(:json_root) { 'image' }

    it 'does nothing to a not owned asset' do
      expect {
        patch(:update, :asset => attrs, :id => asset_id)
      }.to raise_error
    end

    context 'for available asset' do
      let(:card) { Fabricate(
        'card/photo', :user => user, :project => project, :board => board) }
      let(:asset) { card.image }
      let(:asset_id) { asset.id }

      before { patch(:update, :id => asset_id, json_root => attrs) }

      context 'with invalid attributes' do
        let(:attrs) { {:attachment => 'STRING'} }

        subject(:api_asset) { json_to_ostruct(response.body) }

        its(:errors) { should_not be_empty }
      end

      context 'with valid attributes' do
        let(:attrs) { Fabricate.attributes_for(:image_to_upload) }

        subject(:api_asset) { json_to_ostruct(response.body, json_root) }

        its('keys.size') { should eq(13) }
        its(:id) { should eq(asset.id) }
        its(:description) { should eq(attrs[:description]) }
        its(:attachment_file_size) { should eq(attrs[:attachment_file_size]) }
        its(:type) { should eq(asset.type.to_s.demodulize) }
        its(:user_id) { should eq(asset.user.id) }
        its(:board_id) { should eq(asset.board.id) }
        its(:whiteboard_id) { should be_blank }
        its(:project_id) { should eq(asset.project.id) }
        its(:assetable_type) { should eq(asset.assetable_type) }
        its(:assetable_id) { should eq(card.id) }

        context 'with downloadable attachment URL' do
          let(:image_url) { URI.parse('http://test.example.com/test.png') }
          let(:image) do
            test_file = Rails.root.join('spec', 'fixtures', 'test.png')
            io = StringIO.new(test_file.read)
            io.should_receive(:content_type).and_return('image/png')
            io
          end

          let(:attrs) {
            OpenURI.should_receive(:open_uri).and_return(image)
            Fabricate.attributes_for(:image_to_upload, :attachment => image_url)
          }

          its('keys.size') { should eq(13) }
        end
      end
    end
  end

  describe '#create' do
    let(:asset_attrs) { Fabricate.attributes_for(:image_to_upload) }
    let(:json_root) { 'image' }

    before { post(:create, json_root => asset_attrs) }

    context 'with wrong parameters' do
      let(:asset_attrs) {
        Fabricate.attributes_for(:image, :attachment => 'WRONG') }

      subject(:api_asset) { json_to_ostruct(response.body) }

      its('errors') { should_not be_blank }
    end

    context 'with missing parameters' do
      subject(:api_asset) { json_to_ostruct(response.body) }

      its('errors') { should_not be_blank }
    end

    context 'with valid parameters' do
      let(:asset_attrs) { Fabricate.attributes_for(:image_to_upload,
        :user => user, :project => project, :board => board, :type => 'Image',
        :assetable_type => project.class, :assetable_id => project.id)
      }

      subject(:api_asset) { json_to_ostruct(response.body, json_root) }

      its('keys.size') { should eq(13) }
      its(:id) { should_not be_nil }
      its(:description) { should eq(asset_attrs[:description]) }
      its(:type) { should eq(asset_attrs[:type].to_s.demodulize) }
      its(:attachment) { should_not be_empty }
      its(:user_id) { should eq(user.id) }
      its(:board_id) { should eq(board.id) }
      its(:whiteboard_id) { should be_blank }
      its(:project_id) { should eq(project.id) }
      its(:assetable_type) { should eq(project.class.to_s) }
      its(:assetable_id) { should eq(project.id) }

      context 'for logo' do
        let(:asset_attrs) { Fabricate.attributes_for(:image_to_upload,
          :user => user, :project => project, :type => 'Logo',
          :assetable_type => project.class, :assetable_id => project.id)
        }
        let(:json_root) { 'logo' }

        its('keys.size') { should eq(13) }
      end

      context 'for cover' do
        let(:asset_attrs) { Fabricate.attributes_for(:image_to_upload,
          :user => user, :board => board, :type => 'Cover') }
        let(:json_root) { 'cover' }

        its('keys.size') { should eq(13) }
      end

      context 'with downloadable attachment URL' do
        let(:image_url) { URI.parse('http://test.example.com/test.png') }
        let(:image) do
          test_file = Rails.root.join('spec', 'fixtures', 'test.png')
          io = StringIO.new(test_file.read)
          io.should_receive(:content_type).and_return('image/png')
          io
        end

        let(:asset_attrs) {
          OpenURI.should_receive(:open_uri).and_return(image)

          Fabricate.attributes_for(:image_to_upload, :user => user,
            :project => project, :board => board, :attachment => image_url,
            :assetable_type => project.class, :assetable_id => project.id)
        }
        let(:json_root) { asset_attrs[:type].downcase }

        its('keys.size') { should eq(13) }
      end
    end
  end

  describe '#destroy' do
    let(:asset_id) { rand(99..999) }

    before { delete(:destroy, :id => asset_id) }

    its('response.status') { should eq(400) }
    its('response.body') { should be_blank }

    context 'for an available asset' do
      let(:card) { Fabricate(
        'card/photo', :user => user, :project => project, :board => board) }
      let(:asset_id) { card.image.id }

      its('response.status') { should eq(204) }
      its('response.body') { should be_blank }
    end
  end
end
