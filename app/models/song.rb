class Song < ActiveRecord::Base
    validates :title, presence: true
    validates :artist_name, presence: true
    validate :invalid_release_year_if_released_true
    validate :release_year_included?
    validate :invalid_if_artist_releases_song_same_year

    def invalid_release_year_if_released_true
        if released == true && release_year.blank?
            errors.add(:release_year, "release year must be present if Song is released")
        end
    end

    def release_year_included?
        if Array(1..Time.new.year.to_i).include?(release_year)
            true
        elsif release_year.nil?
            true
        else
            errors.add(:release_year, "release year must not be in the future")
        end
    end

    def invalid_if_artist_releases_song_same_year
        Song.all.each { |song| 
            if song.title == title && song.release_year == release_year
                errors.add(:title, "title of song already released this year")
            end
        }
    end
end
