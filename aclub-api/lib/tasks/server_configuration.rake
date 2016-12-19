namespace :server_configuration do
  desc "initialize server configuration, can run multiple time with no harm"
  task initialize: :environment do
    ServerConfiguration.event_winning_rate
    ServerConfiguration.event_winner_limitation
  end

end
