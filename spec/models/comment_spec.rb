require 'spec_helper'

describe Comment do
  let(:comment) { Fabricate(:comment) }

  it { should have_many(:comments).dependent(:destroy) }
  it { should belong_to(:parent_comment) }
  it { should belong_to(:user) }
  it { should belong_to(:board) }
  it { should belong_to(:project) }

  it { should validate_presence_of(:content) }

  context 'instance' do
    subject { comment }

    it { should be_valid }
    its(:parent_comment) { should be_nil }
    its(:imported?) { should be_false }
    its('author.nicename') { should eq(comment.user.nicename) }

    context 'sanitizes #content' do
      let(:content) { Faker::HTMLIpsum.body }

      before { comment.update_attributes(:content => content) }

      its(:content) {
        should eq(Sanitize.clean(content)) }
    end

    context 'having a parent comment' do
      let(:comment) { Fabricate(:comment_with_parent) }

      its(:parent_comment) { should_not be_nil }
    end

    context '#imported?' do
      let(:comment) { Fabricate(:comment_from_angel_list) }

      its(:imported?) { should be_true }
      its('author.nicename') { should eq(comment.angel_list_author_name) }
    end
  end

end
