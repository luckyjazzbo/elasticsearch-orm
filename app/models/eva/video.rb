module Eva
  module Elastic
    class Video < Resource
      field :clip_id,         type: :string, index: :not_analyzed
      field :titles
      field :descriptions
      field :clip_duration,   type: :float
      array :midroll_offsets, type: :float

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

        field :image do
          field :url, type: :string, index: :not_analyzed
        end
      end
    end
  end
end
