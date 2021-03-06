require 'spec_helper'

describe Api::V1::InvitationsController do
  let(:user) { Fabricate(:user) }

  before do
    controller.stub(:current_account) { user }
  end

  describe '#index' do
    let(:invite_ids) { [] }
    before { get(:index, :ids => invite_ids) }

    subject(:api_invites) { json_to_ostruct(response.body) }

    its(:invitations) { should be_empty }

    context 'for owned invitations' do
      let(:invite_ids) do
        3.times.collect{ Fabricate(:invitation, :user => user).id }
      end

      its('invitations.size') { should eq(user.invitations.count) }
    end

    context 'for not owned invitations' do
      let(:invite_ids) do
        3.times.collect{ Fabricate(:invitation).id }
      end

      its(:invitations) { should be_empty }
    end
  end

  describe '#show' do
    include AvatarHelper

    let(:invite) { Fabricate(:invitation) }
    let(:invite_id) { invite.id }

    context 'for a not owned invitation' do
      it 'raises not found' do
        expect{
          get(:show, :id => invite_id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'for an owned invitation' do
      let(:invite) { Fabricate(:invitation, :user => user) }

      before { get(:show, :id => invite_id) }

      subject(:api_invite) { json_to_ostruct(response.body, :invitation) }

      its('keys.size') { should eq(8) }
      its(:id) { should eq(invite.id) }
      its(:email) { should eq(invite.email) }
      its(:user_id) { should eq(invite.user.id) }
      its(:project_id) { should be_nil }
      its(:board_id) { should be_nil }
      its(:membership_id) { should be_nil }
      its(:membership_type) { should be_blank }
      its(:avatar_url) { should eq(gravatar_uri(invite.email)) }

      context 'of board' do
        let(:invite) { Fabricate(:board_invitation, :user => user) }

        its('keys.size') { should eq(8) }
        its(:project_id) { should be_nil }
        its(:board_id) { should eq(invite.invitable.id) }
        its(:membership_id) { should be_nil }
        its(:membership_type) { should eq(BoardMembership.name.parameterize) }
      end

      context 'of project' do
        let(:invite) { Fabricate(:project_invitation, :user => user) }

        its('keys.size') { should eq(8) }
        its(:project_id) { should eq(invite.invitable.id) }
        its(:board_id) { should be_nil }
        its(:membership_id) { should be_nil }
        its(:membership_type) {should eq(ProjectMembership.name.parameterize)}
      end

      context 'with invitee' do
        let(:invite) { Fabricate(:board_invitee, :user => user) }

        its('keys.size') { should eq(8) }
        its(:board_id) { should eq(invite.invitable.id) }
        its(:membership_id) { should eq(invite.membership.id) }
        its(:membership_type) {should eq(BoardMembership.name.parameterize)}
      end
    end
  end

  describe '#create' do
    let(:invite_attrs) { Fabricate.attributes_for(:invitation) }
    let(:invite) { user.invitations.first }

    before { post(:create, :invitation => invite_attrs) }

    subject(:api_invite) { json_to_ostruct(response.body, :invitation) }

    its('keys.size') { should eq(8) }
    its(:id) { should eq(invite.id) }
    its(:email) { should eq(invite.email) }
    its(:user_id) { should eq(invite.user.id) }
    its(:project_id) { should be_nil }
    its(:board_id) { should be_nil }
    its(:membership_id) { should be_nil }
    its(:membership_type) { should be_blank }
    its(:membership_type) { should be_blank }
    its(:avatar_url) { should_not be_blank }

    context 'when some parameter is missing' do
      let(:invite_attrs) { Fabricate.attributes_for(:invitation).except(:email)}

      subject(:api_invite) { json_to_ostruct(response.body) }

      its('keys.size') { should eq(1) }
      its(:errors) { should_not be_empty }
    end

    context 'with invitable set' do
      let(:project) { Fabricate(:project, :user => user) }
      let(:invite_attrs) do
        Fabricate.attributes_for(:invitation).merge(
          {:invitable_id => project.id, :invitable_type => 'Project'} )
      end

      subject(:api_invite) { json_to_ostruct(response.body, :invitation) }

      its('keys.size') { should eq(8) }
      its(:id) { should_not be_nil }
      its(:email) { should eq(invite_attrs['email']) }
      its(:user_id) { should eq(user.id) }
      its(:project_id) { should eq(project.id) }
      its(:board_id) { should be_nil }
      its(:membership_id) { should be_blank }
      its(:membership_type) { should_not be_blank }
    end

    context 'when email is registered and no invitable set' do
      let(:invitee) { Fabricate(:user) }
      let(:invite_attrs) do
        Fabricate.attributes_for(:invitation, :email => invitee.email)
      end

      subject(:api_invite) { json_to_ostruct(response.body) }

      its('keys.size') { should eq(1) }
      its(:errors) { should_not be_empty }
    end

    context 'when email is registered' do
      let(:invitee) { Fabricate(:user) }
      let(:project) { Fabricate(:project, :user => user) }
      let(:invite_attrs) do
        Fabricate.attributes_for(:invitation, :email => invitee.email).merge(
          {:invitable_id => project.id, :invitable_type => 'Project'} )
      end

      subject(:api_invite) { json_to_ostruct(response.body, :invitation) }

      its('keys.size') { should eq(8) }
      its(:id) { should be_nil }
      its(:email) { should eq(invitee.email) }
      its(:user_id) { should eq(user.id) }
      its(:project_id) { should eq(project.id) }
      its(:board_id) { should be_nil }
      its(:membership_id) { should eq(project.memberships.first.id) }
      its(:membership_type) { should_not eq(project.memberships.first.id) }

      it 'it creates a membership' do
        project.members.should include(invitee)
      end
    end
  end

  describe '#destroy' do
    let(:invite) { Fabricate(:invitation) }
    let(:invite_id) { invite.id }

    before { delete(:destroy, :id => invite_id) }

    its('response.status') { should eq(400) }
    its('response.body') { should be_blank }

    context 'for an available invite' do
      let(:invite) { Fabricate('invitation', :user => user) }
      let(:invite_id) { invite.id }

      its('response.status') { should eq(204) }
      its('response.body') { should be_blank }
    end
  end
end
