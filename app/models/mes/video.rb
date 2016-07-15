module Mes
  module Elastic
    class Video < Resource
      LANGS = %i(default en de).freeze

      object :titles do
        LANGS.each do |lang|
          field lang, type: :string
        end
      end
      object :descriptions do
        LANGS.each do |lang|
          field lang, type: :string
        end
      end
      field :clip_duration,   type: :float
      array :midroll_offsets, type: :float
      field :created_at,      type: :float
      field :modified_at,     type: :float
      array :taxonomies,      type: :string, index: :not_analyzed

      object :image do
        field :url, type: :string, index: :not_analyzed
      end

      object :ad_groups do
        LANGS.each do |lang|
          object lang do
            array :prerolls,  type: :string, index: :not_analyzed
            array :midrolls,  type: :string, index: :not_analyzed
            array :postrolls, type: :string, index: :not_analyzed
          end
        end
      end

      object :content_owner do
        field :display_name, type: :string, index: :not_analyzed
        field :link_url,     type: :string, index: :not_analyzed

        object :image do
          field :url, type: :string, index: :not_analyzed
        end
      end
    end
  end
end
