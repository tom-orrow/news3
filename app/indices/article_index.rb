ThinkingSphinx::Index.define :article, with: :active_record, delta: true do
  indexes title
  indexes description
  indexes body
  indexes tags.name, as: :tags

  has :active
end
