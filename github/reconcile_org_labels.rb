#!/usr/bin/env ruby

require_relative 'github_init'

class Reconcile
  attr_reader :http
  attr_reader :uri

  def initialize(http, uri)
    @http = http
    @uri = uri
  end

  def self.build(http, repo)
    uri = base_uri + "repos/#{org_name}/#{repo}/labels"

    new(http, uri)
  end

  def self.call(http, repo)
    instance = build(http, repo)
    instance.()
  end

  def call
    org_labels.each do |label_data|
      label = Label.org_label(label_data)

      labels[label.name] = label
    end

    get_request = Net::HTTP::Get.new(uri)
    repo_labels = http_request(http, get_request) do |get_response|
      json_data = get_response.body
      JSON.parse(json_data, symbolize_names: true)
    end

    repo_labels.each do |label_data|
      name = label_data.fetch(:name)

      label = labels[name]

      if not label.nil?
        color = label_data.fetch(:color)
        description = label_data.fetch(:description)
        label.repo_label_data(color, description)
      else
        label = Label.repo_label(label_data)
        labels[name] = label
      end
    end

    labels.each do |name, label|
      if label.current?
        next
      elsif label.missing?
        request = Net::HTTP::Post.new(uri)
        data = { name:, color: label.correct_color, description: label.correct_description }
      else
        label_uri = label_uri(name)

        if label.obsolete?
          request = Net::HTTP::Delete.new(label_uri)
        else
          request = Net::HTTP::Patch.new(label_uri)
          data = label.patch_data
        end
      end

      if not data.nil?
        json = JSON.generate(data)
        request.body = json
      end

      http_request(http, request)
    end
  end

  def label_uri(name)
    url_encoded_name = ERB::Util.url_encode(name)

    URI("#{self.uri}/#{url_encoded_name}")
  end

  def org_labels
    @org_labels ||= get_org_labels
  end

  def get_org_labels
    labels_text = ENV.fetch('LABELS') do
      abort "LABELS isn't set"
    end

    labels_text.each_line.map do |json|
      JSON.parse(json, symbolize_names: true)
    end
  end

  def labels
    @labels ||= {}
  end
end

Label = Struct.new(:name, :color, :description, :correct_color, :correct_description, :extant) do
  alias :extant? :extant

  def self.org_label(label_data)
    name = label_data.fetch(:name)
    correct_color = label_data.fetch(:color)
    correct_description = label_data.fetch(:description)
    extant = false

    new(name:, correct_color:, correct_description:, extant:)
  end

  def self.repo_label(label_data)
    name = label_data.fetch(:name)
    color = label_data.fetch(:color)
    description = label_data.fetch(:description)

    label = new(name:)
    label.repo_label_data(color, description)
    label
  end

  def repo_label_data(color, description)
    self.color = color
    self.description = description
    self.extant = true
  end

  def missing?
    !extant?
  end

  def obsolete?
    return false if missing?

    correct_color.nil? && correct_description.nil?
  end

  def divergent?
    return false if missing?
    return false if obsolete?

    color != correct_color || description != correct_description
  end

  def current?
    return false if missing?
    return false if obsolete?
    return false if divergent?

    true
  end

  def patch_data
    data = {}

    if color != correct_color
      data[:color] = correct_color
    end

    if description != correct_description
      data[:description] = correct_description
    end

    data
  end
end

def repo_uri(repo)
  base_uri + "repos/#{org_name}/#{repo}/labels"
end

puts <<~TEXT

Reconcile Labels for #{org_name}
- - -
TEXT

use_ssl = base_uri.scheme == 'https'
Net::HTTP.start(base_uri.hostname, use_ssl:) do |http|
  repos = get_repos(http)

  repos.each do |repo|
    Reconcile.(http, repo)
  end
end
