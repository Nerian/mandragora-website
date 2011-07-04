desc "Build the static website under _site"
task :build do
  sh 'rm -rf _site'
  sh "jekyll"
end

desc "Rebuild the static pages and run the server"
task :run do
  sh 'rm -rf _site'
  sh "jekyll"
  sh "rackup config.ru -p 3000"
end

task :push do
  sh 'rm -rf _site'
  sh "jekyll"
  sh "git push && git push heroku"
end

