module Eva
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
      field :created_at,          type: :float
      field :modified_at,         type: :float
      field :version,             type: :float
      field :tenant_id,           type: :string, index: :not_analyzed
      field :duration,            type: :float
      array :keywords,            type: :string

      field :copyright,           type: :string
      field :language,            type: :string, index: :not_analyzed
      field :release_date,        type: :string
      field :source_company,      type: :string
      field :product_placement,   type: :boolean
      field :status,              type: :string, index: :not_analyzed
      field :start_date_absolute, type: :integer
      field :end_date_absolute,   type: :integer

      object :age_ratings do
        field :FSK,  type: :string, index: :not_analyzed
        field :CARA, type: :string, index: :not_analyzed
      end

      array :geo_locations,      type: :string, index: :not_analyzed
      field :transcoding_status, type: :integer
      field :is_deleted,         type: :boolean
      field :is_locked,          type: :boolean
      field :drm,                type: :boolean
      field :entitlement,        type: :boolean
      array :device_classes,     type: :string, index: :not_analyzed # DEVICE_CLASSES
      object :bandwidth_max do
        DEVICE_CLASSES.each do |device_class|
          field device_class, type: :integer
        end
      end
      field :max_resolution, type: :integer

      array :midroll_offsets,    type: :float
      array :taxonomies,         type: :string, index: :not_analyzed

      object :image do
        field :url, type: :string, index: :not_analyzed
      end

      object :licence_profile do
        field :created_at,          type: :float
        field :modified_at,         type: :float
        field :version,             type: :float
        field :status,              type: :string, index: :not_analyzed # %i(NOT_READY READY)
        field :type,                type: :string, index: :not_analyzed # %i(SYNDICATION MDS_PROFILE)
        field :id,                  type: :string, index: :not_analyzed
        field :tenant_id,           type: :string, index: :not_analyzed
        field :name,                type: :string
        field :name_short,          type: :string
        field :start_date,          type: :float
        field :end_date,            type: :float
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
