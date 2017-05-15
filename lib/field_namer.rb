class FieldNamer
  def initialize(fully_qualified_name, content_item)
    @fully_qualified_name = fully_qualified_name
    @content_item = content_item
  end

  def human_name
    human_parts.join(" ➡ ")
  end

  private

  attr_reader :fully_qualified_name, :content_item

  def fully_qualified_parts
    fully_qualified_name.split(".")
  end

  def human_parts
    fully_qualified_parts.map do |field|
      prefix = nil
      if field.end_with?("]")
        tokens = field.split("[")
        index = tokens.last.split("]").first.to_i
        prefix = (index + 1).ordinalize
        field = tokens.first

        if field == "parts"
          field = "#{content_item["details"]["parts"][index]["title"]} Part"
          prefix = nil
        end

        field = field.singularize
      end

      field = field
        .gsub("_", " ")
        .split.map(&:capitalize).join(' ')
        .gsub("Id", "ID")
        .gsub("Api", "API")

      next "#{prefix} #{field}" if prefix
      field
    end
  end
end