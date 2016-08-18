execute "Create GitHub's webhook" do
	user "deploy"
	command "curl -u '#{node[:github_account_name]}:#{node[:github_personal_token]}' -v -H 'Content-Type: application/json' -X POST -d '{\"name\": \"web\", \"active\": true, \"events\": [\"push\"], \"config\": {\"url\": \"#{node[:webapp_url]}\", \"content_type\": \"json\"}}' https://api.github.com/repos/#{node[:github_account_name]}/#{node[:github_repo_name]}/hooks 2>&1"
end
