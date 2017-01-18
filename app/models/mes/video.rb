module Mes
  module Elastic
    class Video < Resource
      LANGS = %i(default en de).freeze
      DEVICE_CLASSES=%i(BROWSER MOBILE SETTOPBOX SMARTTV HBBTV GAMECONSOLE HDMISTICK).freeze

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

      array :geo_locations,   type: :string, index: :not_analyzed
      array :keywords,        type: :string, index: :not_analyzed
      array :midroll_offsets, type: :double

      field :clip_duration,     type: :double
      field :tenant_id,         type: :string, index: :not_analyzed
      field :created_at,        type: :double
      field :modified_at,       type: :double
      field :start_date,        type: :double
      field :end_date,          type: :double
      field :is_deleted,        type: :boolean
      field :is_locked,         type: :boolean
      field :internal_status,   type: :string, index: :not_analyzed
      field :product_placement, type: :boolean
      field :source_id,         type: :string, index: :not_analyzed

      object :image do
        field :url, type: :string, index: :not_analyzed
      end

      object :license_profile do
        field :created_at,          type: :double
        field :modified_at,         type: :double
        field :version,             type: :float
        field :status,              type: :string, index: :not_analyzed # %i(NOT_READY READY) # TODO remove, not used
        field :type,                type: :string, index: :not_analyzed # %i(SYNDICATION MDS_PROFILE)
        field :id,                  type: :string, index: :not_analyzed
        field :tenant_id,           type: :string, index: :not_analyzed
        field :name,                type: :string
        field :name_short,          type: :string
        field :start_date,          type: :double
        field :end_date,            type: :double
        array :products,            type: :string, index: :not_analyzed # %i(FIXED_PRICE ADS)
        array :sales_houses,        type: :string, index: :not_analyzed
        array :geo_locations,       type: :string, index: :not_analyzed
        array :device_classes,      type: :string, index: :not_analyzed # DEVICE_CLASSES
        object :bandwidth_max do
          DEVICE_CLASSES.each do |device_class|
            field device_class, type: :integer
          end
        end
        field :max_resolution,      type: :string, index: :not_analyzed # %i(SD HD720 HD1080 4K)
        array :publisher_whitelist, type: :string, index: :not_analyzed
        array :publisher_blacklist, type: :string, index: :not_analyzed
        field :drm,                 type: :boolean
        field :entitlement,         type: :boolean
      end

      array :ad_groups, type: :object do
        field :geolocation,    type: :string, index: :not_analyzed
        field :sales_house_id, type: :string, index: :not_analyzed
        object :reach_measured do
          array :prerolls,     type: :string, index: :not_analyzed
          array :midrolls,     type: :string, index: :not_analyzed
          array :postrolls,    type: :string, index: :not_analyzed
        end
        object :non_reach_measured do
          array :prerolls,     type: :string, index: :not_analyzed
          array :midrolls,     type: :string, index: :not_analyzed
          array :postrolls,    type: :string, index: :not_analyzed
        end
      end

      object :content_owner do
        field :display_name, type: :string, index: :not_analyzed
        field :link_url,     type: :string, index: :not_analyzed

        object :image do
          field :url, type: :string, index: :not_analyzed
        end
      end

      array :taxonomies, type: :object do
        field :id,                  type: :string, index: :not_analyzed
        field :parent_id,           type: :string, index: :not_analyzed
        field :type_id,             type: :string, index: :not_analyzed
        field :image_id,            type: :string, index: :not_analyzed

        object :title do
          LANGS.each do |lang|
            field lang, type: :string
          end
        end
      end
    end
  end
end
