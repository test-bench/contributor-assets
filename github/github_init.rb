require 'json'
require 'net/http'
require 'erb'
require 'pathname'

def base_uri
  @base_uri ||= URI("https://api.github.com")
end

def tmp_dir
  @tmp_dir ||= Pathname(File.expand_path('../tmp', __dir__)).relative_path_from(Dir.pwd)
end

def org_name
  ENV.fetch('ORG_NAME') do
    git_authority_path = ENV.fetch('GIT_AUTHORITY_PATH')
    git_authority_path.delete_prefix('git@github.com:')
  end
end

def github_token
  ENV.fetch('GITHUB_TOKEN') do
    abort "GITHUB_TOKEN isn't set"
  end
end

def command(command)
  puts command

  if dry_run?
    puts "(Dry run, did not run)"
  else
    system(command) or abort "Exit: #{$?}"
  end
end

def get_repos(http)
  per_page = 50

  repos = Set.new

  page=0

  loop do
    uri = base_uri + "orgs/#{org_name}/repos?per_page=#{per_page}&page=#{page}"

    get_request = Net::HTTP::Get.new(uri)

    batch = []

    http_request(http, get_request) do |get_response|
      json_data = get_response.body

      data = JSON.parse(json_data, symbolize_names: true)

      data.each do |repo_data|
        repo = repo_data.fetch(:name)

        batch << repo
      end
    end

    batch.each do |repo|
      repos << repo
    end

    if batch.size < per_page
      break
    end
  end

  repos.to_a
end

def http_request(http, request, &response_action)
  request.basic_auth(github_token, 'x-oauth-basic')
  request['Accept'] = 'application/vnd.github.v3+json'

  puts "#{request.method} #{request.uri}"

  request_body = request.body.to_s
  if not request_body.empty?
    puts request_body
  end

  if request.is_a?(Net::HTTP::Get)
    dry_run = false
  else
    dry_run = self.dry_run?
  end

  if not dry_run
    return_value = nil

    http.request(request) do |response|
      if not Net::HTTPSuccess === response
        abort "Server response: #{response.inspect}"
      end

      puts "#{response.code} #{response.message}"

      if not response_action.nil?
        return_value = response_action.(response)
      end
    end
  else
    puts "(Dry run, no response)"
  end

  puts

  return_value
end

def dry_run
  ENV.fetch('DRY_RUN', 'off')
end

def dry_run?
  dry_run == 'on'
end
