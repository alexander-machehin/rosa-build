namespace :resque do
  desc 'Stop all Resque workers'
  task :stop_workers => :environment do
    pids = []
    Resque.workers.each do |worker|
      pids << worker.to_s.split(/:/).second
    end
    system("kill -QUIT #{pids.join(' ')}") if pids.size > 0
  end
end