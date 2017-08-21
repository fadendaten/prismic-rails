# :nodoc:
module PrismicRails
  # The PrismicRails::Document is a wrapper class around Prismic::Document to
  # support custom features like to_html, to_text and to handle nil documents.
  class Document

    # Creates a new PrismicRails::Document
    # ====
    #   +document+ A Prismic::Document
    def initialize(document)
      @document = document || PrismicRails::NilDocument.new
    end

    # Returns the document as safe html
    def to_html
      @document.as_html(nil).html_safe
    end

    # Returns only the text of a document
    def to_text
      @document.as_text
    end

    # Finds a fragment of a specific type in a document
    # ====
    #    +type+ 'text', 'image' etc
    def find_fragment(type)
      fragment = @document.fragments[type]
      return PrismicRails::Fragment.new(fragment) || NilDocument.new
    end

    # Tests if the document has the type type.
    # ====
    #    +type+ 'text', 'image' etc
    def is_type? type
      type == @document.type
    end
  end
end
