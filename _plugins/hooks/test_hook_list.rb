module Jekyll
  module Books
    extend self
  end

  Jekyll::Hooks.register :site, :after_init do |data|
    puts 'site   after_init 在网站初始化时，但是在设置和渲染之前，适合用来修改网站的配置项'
    # puts data
  end
  Jekyll::Hooks.register :site, :after_reset do |data|
    puts 'site   after_reset 网站重置之后'
    # puts data
  end
  Jekyll::Hooks.register :site, :post_read do |site|
    puts 'site   post_read 在网站数据从磁盘中读取并加载之后'
    # puts site
    collections = site.collections
    posts = collections['posts']
    docs = posts.docs
    new_docs = Array.new
    docs.each do |doc|
      data = doc.data
      new_docs << doc
      new_docs << doc
      new_docs << doc
      all = 0
      books = data['books']
      unless books.empty?
        books.each do |book|
          tags = Utils.pluralized_array_from_hash(book, 'tag', 'tags')
          unless tags.empty?
            data['tags'] = data['tags'] | tags
            puts data['tags']
          end
          categories = Utils.pluralized_array_from_hash(book, 'category', 'categories')
          unless categories.empty?
            data['categories'] = data['categories'] | categories
            puts data['categories']
          end
          book['moneys'] = Utils.pluralized_array_from_hash(book, 'money', 'moneys')
          book['names'] = Utils.pluralized_array_from_hash(book, 'name', 'names')
          book['moneys'].each do |money|
            all += money.to_i
          end
          puts book
        end
      end
      data['all'] = all
      data['title'] = all
      puts data
    end
    posts.docs = new_docs
  end
  Jekyll::Hooks.register :site, :pre_render do |data|
    puts 'site   pre_render 在渲染整个网站之前'
    # puts data
  end
  Jekyll::Hooks.register :site, :post_render do |data|
    puts 'site   post_render 在渲染整个网站之后，但是在写入任何文件之前'
    # puts data
  end
  Jekyll::Hooks.register :site, :post_write do |data|
    puts 'site   post_write 在将整个网站写入磁盘之后'
    # puts data
  end
  Jekyll::Hooks.register :pages, :post_init do |data|
    puts 'pages   post_init 每次页面被初始化的时候'
    # puts data
  end
  Jekyll::Hooks.register :pages, :pre_render do |data|
    puts 'pages   pre_render 在渲染页面之前'
    # puts data
  end
  Jekyll::Hooks.register :pages, :post_render do |data|
    puts 'pages   post_render 在页面渲染之后，但是在页面写入磁盘之前'
    # puts data
  end
  Jekyll::Hooks.register :pages, :post_write do |data|
    puts 'pages   post_write 在页面写入磁盘之后'
    # puts data
  end
  Jekyll::Hooks.register :posts, :post_init do |data|
    puts 'posts   post_init 每次博客被初始化的时候'
    # puts data
  end
  Jekyll::Hooks.register :posts, :pre_render do |data|
    puts 'posts   pre_render 在博客被渲染之前'
    # puts data
  end
  Jekyll::Hooks.register :posts, :post_render do |data|
    puts 'posts   post_render 在博客渲染之后，但是在被写入磁盘之前'
    # puts data
  end
  Jekyll::Hooks.register :posts, :post_write do |data|
    puts 'posts   post_write 在博客被写入磁盘之后'
    # puts data
  end
  Jekyll::Hooks.register :documents, :post_init do |data|
    puts 'documents   post_init 每次文档被初始化的时候'
    # puts data
  end
  Jekyll::Hooks.register :documents, :pre_render do |data|
    puts 'documents   pre_render 在渲染文档之前'
    # puts data
  end
  Jekyll::Hooks.register :documents, :post_render do |data|
    puts 'documents   post_render 在渲染文档之后，但是在被写入磁盘之前'
    # puts data
  end
  Jekyll::Hooks.register :documents, :post_write do |data|
    puts 'documents   post_write 在文档被写入磁盘之后'
    # puts data
  end
end