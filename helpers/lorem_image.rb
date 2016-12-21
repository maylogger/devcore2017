module LoremImage
  def fakepic(width, height, bg = "282828", color = "eae0d0")
    return "http://fakeimg.pl/#{width}x#{height}/#{bg}/#{color}"
  end
  def lorem_pic(width, height, category, gray = nil)
    if gray == true
      return "http://lorempixel.com/g/#{width}/#{height}/#{category}/#{rand(10)}/"
    else
      return "http://lorempixel.com/#{width}/#{height}/#{category}/#{rand(10)}/"
    end
  end
  def lorem_pic_with_index(width, height, category, index, gray = nil)
    if gray == true
      return "http://lorempixel.com/g/#{width}/#{height}/#{category}/#{index}/"
    else
      return "http://lorempixel.com/#{width}/#{height}/#{category}/#{index}/"
    end
  end
  def lorem_pic_with_text(width, height, category, text, gray = nil)
    if gray == true
      return "http://lorempixel.com/g/#{width}/#{height}/#{category}/#{rand(10)}/#{text}/"
    else
      return "http://lorempixel.com/#{width}/#{height}/#{category}/#{rand(10)}/#{text}/"
    end
  end
  def lorem_pic_with_dimensions(width, height, category, gray = nil)
    if gray == true
      return "http://lorempixel.com/g/#{width}/#{height}/#{category}/#{rand(10)}/#{width}x#{height}/"
    else
      return "http://lorempixel.com/#{width}/#{height}/#{category}/#{rand(10)}/#{width}x#{height}/"
    end
  end
  def lorem_pic_with_dimensions_and_index(width, height, category, index, gray = nil)
    if gray == true
      return "http://lorempixel.com/g/#{width}/#{height}/#{category}/#{index}/#{width}x#{height}/"
    else
      return "http://lorempixel.com/#{width}/#{height}/#{category}/#{index}/#{width}x#{height}/"
    end
  end
  def fakeimg(width, height, bg = "282828", color = "eae0d0")
    image_tag "http://fakeimg.pl/#{width}x#{height}/#{bg}/#{color}", width: width, height: height, alt: "#{width}x#{height}"
  end
  def lorem_img(width, height, category, gray = nil)
    if gray == true
      image_tag "http://lorempixel.com/g/#{width}/#{height}/#{category}/#{rand(10)}/", width: width, height: height, alt: category
    else
      image_tag "http://lorempixel.com/#{width}/#{height}/#{category}/#{rand(10)}/", width: width, height: height, alt: category
    end
  end
  def lorem_img_with_text(width, height, category, text, gray = nil)
    if gray == true
      image_tag "http://lorempixel.com/g/#{width}/#{height}/#{category}/#{rand(10)}/#{text}/", width: width, height: height, alt: category
    else
      image_tag "http://lorempixel.com/#{width}/#{height}/#{category}/#{rand(10)}/#{text}/", width: width, height: height, alt: category
    end
  end
  def lorem_img_with_dimensions(width, height, category, gray = nil)
    if gray == true
      image_tag "http://lorempixel.com/g/#{width}/#{height}/#{category}/#{rand(10)}/#{width}x#{height}/", width: width, height: height, alt: category
    else
      image_tag "http://lorempixel.com/#{width}/#{height}/#{category}/#{rand(10)}/#{width}x#{height}/", width: width, height: height, alt: category
    end
  end
  def lorem_img_with_dimensions_and_index(width, height, category, index, gray = nil)
    if gray == true
      image_tag "http://lorempixel.com/g/#{width}/#{height}/#{category}/#{index}/#{width}x#{height}/", width: width, height: height, alt: category
    else
      image_tag "http://lorempixel.com/#{width}/#{height}/#{category}/#{index}/#{width}x#{height}/", width: width, height: height, alt: category
    end
  end
  def lazy_img(width, height, category, gray = nil)
    if gray == true
      tag :img, width: width, height: height, alt: category, class: 'lazy', 'data-original' => "http://lorempixel.com/g/#{width}/#{height}/#{category}/#{rand(10)}/", 'data-src' => "holder.js/#{width}x#{height}/tripmoment/auto"
    else
      tag :img, width: width, height: height, alt: category, class: 'lazy', 'data-original' => "http://lorempixel.com/#{width}/#{height}/#{category}/#{rand(10)}/", 'data-src' => "holder.js/#{width}x#{height}/tripmoment/auto"
    end
  end
end