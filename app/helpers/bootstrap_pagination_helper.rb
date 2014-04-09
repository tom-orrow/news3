module BootstrapPaginationHelper
  class LinkRenderer < WillPaginate::ActionView::LinkRenderer
    protected

      def page_number(page)
        if page == current_page
          link(page, "#", class: 'active')
        else
          link(page, page, rel: rel_value(page))
        end
      end

      def gap
        text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
        %(<li class="disabled"><a>#{text}</a></li>)
      end

      def next_page
        num = @collection.current_page + 1 if @collection.current_page < @collection.total_pages
        previous_or_next_page(num, @options[:next_label], 'next')
      end

      def previous_or_next_page(page, text, classname)
        if page
          link(text, page, class: classname)
        else
          link(text, '#', class: classname << ' disabled')
        end
      end

      def html_container(html)
        tag(:div, tag(:ul, html), container_attributes)
      end

    private

      def link(text, target, attributes = {})
        if target.is_a? Fixnum
          attributes[:rel] = rel_value(target)
          target = url(target)
        end

        attributes[:href] = target unless target == '#'

        classname = attributes[:class]
        attributes.delete(:classname)
        tag(:li, tag(:a, text, attributes), class: classname)
      end
  end
end
