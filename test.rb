require 'octokit'
require 'dependabot/gradle/file_fetcher'
require 'dependabot/gradle/file_parser'
require 'dependabot/source'

target_repo_name = 'verno3632/dependabot_gradle_test'
source = Dependabot::Source.new(provider: 'github', repo: target_repo_name)

client = Octokit::Client.new access_token: ENV['GITHUB_API_TOKEN']
fetcher_class = Dependabot::Gradle::FileFetcher
filenames = client.contents('verno3632/dependabot_gradle_test').map(&:name)

unless fetcher_class.required_files_in?(filenames)
  raise fetcher_class.required_files_message
end

fetcher = fetcher_class.new(source: source, credentials: [{"type" => "git_source", "host" => "github.com", "token" => ENV['GITHUB_API_TOKEN']}])
puts fetcher.files

puts "Fetched #{fetcher.files.map(&:name)}, at commit SHA-1 '#{fetcher.commit}'"


files = fetcher.files

parser_class = Dependabot::Gradle::FileParser
parser = parser_class.new(dependency_files: files, source: source)

dependencies = parser.parse

puts "Found the following dependencies: #{dependencies.map(&:name)}"
