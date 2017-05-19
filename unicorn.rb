#setup user environment
ENV['RACK_ENV'] = 'production'

worker_processes(1)
preload_app true
# user('hosting_soobscha','plex_users')
timeout 40
# listen '/var/sockets/hosting_soobscha/deserial-production.soobscha.sock', :umask => 0117
working_directory '.'
# pid 'tmp/pids/deserial.pid'
stderr_path File.join('log', 'unicorn_stderr.log')
stdout_path File.join('log', 'unicorn_stdout.log')

#stderr_path stderr_log if File.writable? stderr_log
#stdout_path stdout_log if File.writable? stdout_log

GC.respond_to?(:copy_on_write_friendly=) and
GC.copy_on_write_friendly = true

before_fork do |server, worker|
   old_pid = "#{server.config[:pid]}.oldbin"
   if File.exists?(old_pid) && server.pid != old_pid
      begin
         Process.kill("QUIT", File.read(old_pid).to_i)
      rescue Errno::ENOENT, Errno::ESRCH
      end
   end
end
