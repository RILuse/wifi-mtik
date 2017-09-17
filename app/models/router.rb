class Router < ApplicationRecord
  validates :identity, presence: true, uniqueness: true
  validates :ip, presence: true, uniqueness: true, :format => {
      :with => Regexp.union(Resolv::IPv4::Regex, Resolv::IPv6::Regex)
  }
  validates :port, presence: true
  validates :login, presence: true
  validates :password, presence: true


end
