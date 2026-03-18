module RGSS

	@load_path = ["C:/Program Files (x86)/Common Files/Enterbrain/RGSS3/RPGVXAce"]

	class << self
    attr_accessor :load_path
    attr_accessor :load_ext

		def get_file(filename)
			([nil] + RGSS.load_path).each do |directory|
				([''] + load_ext).each do |extname|
					path = File.expand_path filename + extname, directory
					if File.exist? path
						return path
					end
				end
			end
			filename
		end
	end

	self.load_ext  = ['.png', '.jpg', '.gif', '.bmp', '.ogg', '.wma', '.mp3', '.wav', '.mid']
	self.load_path = ["C:/Program Files (x86)/Common Files/Enterbrain/RGSS3/RPGVXAce"]

	
	module Drawable
    attr_accessor :x, :y, :viewport, :created_at
    attr_reader :z, :visible

    def initialize(viewport=nil)
      @created_at  = Time.now
      @viewport    = viewport
    end

    def viewport=(viewport)
      @viewport    = viewport
      self.visible = @visible
    end

    def >(v)
      return false if self.viewport.nil?&&v.viewport
      unless (v.viewport.nil?)
        return false if self.viewport.z<v.viewport.z
        return false if self.viewport.z==v.viewport.z and self.viewport.created_at<v.viewport.created_at
      end
      return false if self.z<v.z
      return false if self.z==v.z and self.y<v.y
      return false if self.z==v.z and self.y==v.y and self.created_at<v.created_at
      return true
    end

    #$a=0
    def <=>(v)
      #print $a+=1
      return 1 if (self>v)
      return -1
    end

    def z=(z)
      return if z==@z
      @z = z
    end

    def y=(y)
      return if y==@y
      @y = y
    end

    def disposed?
      @disposed
    end

    def dispose
      @disposed = true
      RGSS.resources.delete self
    end

    def draw(destination=Graphics)
      raise NotImplementedError
    end

  end
end