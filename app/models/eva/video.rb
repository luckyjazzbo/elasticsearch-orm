module Eva
  module Elastic
    class Video < Resource
      field :tenant_id,         type: :string, index: :not_analyzed
      field :duration,          type: :float
      field :title,             type: :object
      field :description,       type: :object
      array :keywords,          type: :string, index: :not_analyzed
      field :copyright,         type: :string, index: :not_analyzed
      field :language,          type: :string, index: :not_analyzed
      field :release_date,      type: :string, index: :not_analyzed
      field :taxonomies,        type: :object
      field :source_company,    type: :string, index: :not_analyzed
      field :product_placement, type: :boolean
      field :created_at,        type: :float
      field :modified_at,       type: :float
      field :version,           type: :integer
      field :status,            type: :string, index: :not_analyzed

      object :images do
        field :id,                type: :string, index: :not_analyzed
        field :tenant_id,         type: :string, index: :not_analyzed
        field :type,              type: :string, index: :not_analyzed
        field :url,               type: :string, index: :not_analyzed
        field :url_external_page, type: :string, index: :not_analyzed
        field :name,              type: :string, index: :not_analyzed
        field :created_at,        type: :float
        field :modified_at,       type: :float
        field :version,           type: :integer
        field :status,            type: :string, index: :not_analyzed
      end

      object :license_profiles do
        field :type,                type: :string, index: :not_analyzed
        field :id,                  type: :string, index: :not_analyzed
        field :tenant_id,           type: :string, index: :not_analyzed
        field :name,                type: :string, index: :not_analyzed
        field :name_short,          type: :string, index: :not_analyzed
        field :start_date,          type: :integer
        field :end_date,            type: :integer
        field :mds_profile,         type: :boolean
        array :products,            type: :string, index: :not_analyzed
        array :sales_houses,        type: :string, index: :not_analyzed
        array :geo_locations,       type: :string, index: :not_analyzed
        array :device_classes,      type: :string, index: :not_analyzed
        field :bandwidth_max,       type: :object
        array :publisher_whitelist, type: :string, index: :not_analyzed
        array :publisher_blacklist, type: :string, index: :not_analyzed
        field :max_resolution,      type: :string, index: :not_analyzed
        field :drm,                 type: :boolean
        field :entitlement,         type: :boolean
        field :created_at,          type: :float
        field :modified_at,         type: :float
        field :version,             type: :integer
        field :status,              type: :string, index: :not_analyzed
      end

      object :ad_profiles do
        field :id,         type: :string, index: :not_analyzed
        field :tenant_id,  type: :string, index: :not_analyzed
        field :name,       type: :string, index: :not_analyzed
        field :name_short, type: :string, index: :not_analyzed
        field :start_date, type: :integer
        field :end_date,   type: :integer

        field :created_at,  type: :float
        field :modified_at, type: :float
        field :version,     type: :integer
        field :status,      type: :string, index: :not_analyzed

        # TODO: implement support of array of objects
        array :ad_groups, type: :object do
          field :geolocation, type: :string, index: :not_analyzed

          object :reach_measured do
            array :prerolls,  type: :string, index: :not_analyzed
            array :midrolls,  type: :string, index: :not_analyzed
            array :postrolls, type: :string, index: :not_analyzed
          end

          object :non_reach_measured do
            array :prerolls,  type: :string, index: :not_analyzed
            array :midrolls,  type: :string, index: :not_analyzed
            array :postrolls, type: :string, index: :not_analyzed
          end
        end
      end

      object :price_profiles do
        field :id,          type: :string, index: :not_analyzed
        field :created_at,  type: :float
        field :modified_at, type: :float
        field :version,     type: :integer
        field :status,      type: :string, index: :not_analyzed
      end
    end
  end
end
