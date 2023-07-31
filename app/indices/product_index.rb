ThinkingSphinx::Index.define :product, with: :active_record do
     indexes :name
     indexes :description
end
