require 'spec_helper'

describe Card do
  it { should belong_to(:user) }
  it { should belong_to(:board) }
  it { should belong_to(:project) }
  it { should belong_to(:topic) }
  it { should have_many(:activities).dependent('') }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:endorses).dependent('') }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:board) }
  it { should validate_presence_of(:topic) }
  it { should ensure_inclusion_of(:style).in_array(Card::STYLES) }
  it { should validate_numericality_of(:position) }

  context 'instance' do
    let(:card) { Fabricate(:card) }

    subject { card }

    its(:position) { should eq(0) }

    context 'sanitizes' do
      let(:content) { Faker::HTMLIpsum.body }

      context '#title' do
        before { card.update_attributes(:title => content[0..250]) }

        its(:title) { should eq(Sanitize.clean(content[0..250])) }
      end

      context '#content' do
        before { card.update_attributes(:content => content) }

        its(:content) { should eq(Sanitize.clean(content)) }
      end
    end
  end

  context 'order defaults to Card#id' do
    let!(:cards) { 3.times.collect{ Fabricate(:card) } }
    let(:ids) { cards.map(&:id) }

    context '#all' do
      subject { Card.all.map(&:id) }

      it { should eq(ids.sort) }
    end
  end

end
