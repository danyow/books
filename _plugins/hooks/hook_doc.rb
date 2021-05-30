module Jekyll
  Jekyll::Hooks.register :site, :after_init do |data|
    Jekyll::Document::DATE_FILENAME_MATCHER = %r!^(?>.+/)*?(\d{2,4}-\d{1,2}-\d{1,2})(-([^/]*))?(\.[^.]+)$!.freeze
  end
  Jekyll::Hooks.register :site, :post_read do |site|
    collections = site.collections
    posts = collections['posts']
    docs = posts.docs
    new_docs = []
    all = 0
    year_all = {}
    month_all = {}
    day_all = {}
    tag_all = {}
    category_all = {}
    docs.each do |doc|
      data = doc.data
      books = data['books']
      unless books.empty?
        books.each do |book|
          categories = Utils.pluralized_array_from_hash(book, 'category', 'categories')
          tags = Utils.pluralized_array_from_hash(book, 'tag', 'tags')
          moneys = Utils.pluralized_array_from_hash(book, 'money', 'moneys')
          names = Utils.pluralized_array_from_hash(book, 'name', 'names')
          #day
          day = book['time'].strftime('%Y/%m/%d')
          month = book['time'].strftime('%Y/%m')
          year = book['time'].strftime('%Y')
          if !day_all.include?(day)
            day_all[day] = 0
          end
          if !month_all.include?(month)
            month_all[month] = 0
          end
          if !year_all.include?(year)
            year_all[year] = 0
          end
          moneys.each do |money|
            day_all[day] += money.to_i
            month_all[month] += money.to_i
            year_all[year] += money.to_i
            all += money.to_i
          end

          # 大于等于
          if (moneys.size <=> names.size) >= 0
            (0..moneys.size - 1).each do |i|
              if categories.size == tags.size
                money = moneys[i]
                name = 'nil'
                name = names[i] if i <= names.size - 1
                # loop
                new_doc = Document.new(doc.path, :site => site, :collection => posts)
                new_doc.data.replace(doc.data)
                new_doc.data['title'] = money
                new_doc.data['excerpt'] = name
                new_doc.data['permalink'] = "/:year/:month/:day/#{money}/"
                #
                tag_i = i
                tag_i = 0 if (categories.size == 1) && (tags.size == 1)
                tag = tags[tag_i]
                category = categories[tag_i]
                if !tag_all.include?(tag)
                  tag_all[tag] = 0
                end
                if !category_all.include?(category)
                  category_all[category] = 0
                end
                tag_all[tag] += money.to_i
                category_all[category] += money.to_i
                new_doc.data['book'] = {
                  'name' => name,
                  'money' => money,
                  'tags' => tag,
                  'categories' => category
                }
                new_doc.data['tags'] = [tag]
                new_doc.data['categories'] = [category]
                new_docs << new_doc
              end
            end
          end
        end
      end
    end
    site.data['money'] = {
      'year' => year_all,
      'month' => month_all,
      'day' => day_all,
      'tag' => tag_all,
      'category' => category_all,
      'all' => all,
    }
    posts.docs = new_docs
  end
end
