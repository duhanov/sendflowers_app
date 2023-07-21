class SearchWord < ActiveRecord::Base
  def self.inc(q, language = 'ru')
    q = q.to_s
    if q.strip != ""
      sw = SearchWord.find_by_q(q)
      if sw.blank?
        sw = SearchWord.new({:q => q, :language => language})
      end
      sw.count_requests = sw.count_requests + 1
      sw.save
    end
  end
end
