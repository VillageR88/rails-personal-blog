module BlogHelper
  class CustomRenderer < Redcarpet::Render::HTML
    def header(text, level)
      class_name = level == 1 ? "" : "pt-[16px]"
      "<h#{level} class='#{class_name} [transition:color_300ms]'>#{text}</h#{level}>"
    end

    def paragraph(text)
      "<p class='p-normal [transition:color_300ms]'>#{text}</p>"
    end

    def block_code(code, language)
      "<pre class='bg-[#201E1D] dark:bg-[#f5f5f5] p-[16px] rounded overflow-x-auto'><code class='[transition:color_300ms]'>#{code}</code></pre>"
    end

    def block_quote(quote)
      "<blockquote class='pl-[16px] border-l-4 border-[#C0BFBF] dark:border-[#34302D] italic [transition:color_300ms,border-color_300ms]'>#{quote}</blockquote>"
    end

    def list(contents, list_type)
      if list_type == :unordered
        "<ul class='list-disc pl-[20px] flex flex-col gap-[8px] marker:text-[0.6em] marker:text-[#34302D] dark:marker:text-[#FEFEFE] [transition:_300ms]'>#{contents}</ul>"
      else
        "<ol class='list-decimal pl-[20px] flex flex-col gap-[8px]'>#{contents}</ol>"
      end
    end

    def list_item(text, list_type)
      "<li>#{text}</li>"
    end

    def table(header, body)
      "<div class='overflow-x-auto my-[16px]'><table class='w-full border-collapse'>#{header}#{body}</table></div>"
    end

    def table_row(content)
      "<tr class='border-b border-[#EFEDEB] dark:border-[#34302D] [transition:border-color_300ms]'>#{content}</tr>"
    end

    def table_cell(content, alignment, header = false)
      tag = header ? 'th' : 'td'
      "<#{tag} class='p-[8px] text-left [transition:color_300ms]'>#{content}</#{tag}>"
    end

    def link(link, title, content)
      "<a href='#{link}' class='text-[#0969DA] hover:underline'>#{content}</a>"
    end

    def image(link, title, alt_text)
      "<img src='#{link}' alt='#{alt_text}' class='max-w-full h-auto rounded'>"
    end
  end

  def markdown(text)
    renderer = CustomRenderer.new
    markdown = Redcarpet::Markdown.new(renderer,
      autolink: true,
      tables: true,
      fenced_code_blocks: true,
      strikethrough: true,
      superscript: true,
      no_intra_emphasis: true
    )
    markdown.render(text).html_safe
  end

  def process_inline_markdown(text)
    text = text.gsub(/\*\*\*(.*?)\*\*\*/, '<strong><em>\1</em></strong>')
        .gsub(/\*\*(.*?)\*\*/, '<strong>\1</strong>')
        .gsub(/\*(.*?)\*/, '<em>\1</em>')
        .gsub(/`(.*?)`/, '<code class="bg-[#f5f5f5] px-[4px] py-[2px] rounded">\1</code>')
        .gsub(/!\[(.*?)\]\((.*?)\)/, '<img src="\2" alt="\1" class="max-w-full h-auto rounded">')
        .gsub(/\[(.*?)\]\((.*?)\)/, '<a href="\2" class="text-[#0969DA] hover:underline">\1</a>')
    text.html_safe
  end
end
