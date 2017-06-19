require 'rails_helper'

describe TeamsController do
  let(:tom) { create(:user, name: 'tom') }
  let(:team) {create(:team, name: 'team', operator: tom)}
  context '#create' do
    before :each do
      allow(controller).to receive(:current_user) { tom }
    end

    it 'if team save failure, should get unprocessable_entity http code' do
      post :create, params: {name: ''}, session: {team_id: team.id}
      expect(response.status).to eq(422)
    end

    it 'if team save success, should get success http code' do
      post :create, params: {name: ''}, session: {team_id: team.id}
      expect(response.status).to eq(200)
    end
  end
end