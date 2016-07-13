module Eva
  module Elastic
    class Video < Resource
      field :titles,          type: :object
      field :descriptions,    type: :object
      field :clip_duration,   type: :float
      array :midroll_offsets, type: :float
      field :created_at,      type: :float
      field :modified_at,     type: :float

      object :image do
        field :url, type: :string, index: :not_analyzed
      end

      object :ad_tags do
        array :prerolls,  type: :string, index: :not_analyzed
        array :midrolls,  type: :string, index: :not_analyzed
        array :postrolls, type: :string, index: :not_analyzed
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
