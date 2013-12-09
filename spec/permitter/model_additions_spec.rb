require "spec_helper"

class Category < ActiveRecord::Base
  unless connection.tables.include?(table_name)
    connection.create_table(table_name) do |t|
      t.boolean :visible
    end
  end
  has_many :articles
end

class Article < ActiveRecord::Base
  unless connection.tables.include?(table_name)
    connection.create_table(table_name) do |t|
      t.integer :category_id
      t.string :name
      t.boolean :published
      t.boolean :secret
      t.integer :priority
    end
  end
  belongs_to :category
  has_many :comments
end

class Comment < ActiveRecord::Base
  unless connection.tables.include?(table_name)
    connection.create_table(table_name) do |t|
      t.integer :article_id
      t.boolean :spam
    end
  end
  belongs_to :article
end

describe Permitter::ModelAdditions do
  before do
    Article.delete_all
    Comment.delete_all

    @permissions = Object.new
    @permissions.extend(Permitter::Permission)

    @article_table = Article.table_name
    @comment_table = Comment.table_name
  end

  it "does not fetch any records when no permissions are defined" do
    Article.create!

    expect(Article.permitted_by(@permissions)).to be_empty
  end

  it "fetches all articles when one can read all" do
    @permissions.allow_action(:articles, [:permitted_by, :show])

    article1 = Article.create!
    article2 = Article.create!

    expect(@permissions).to allow_action(:articles, :show)
    expect(Article.permitted_by(@permissions)).to eq([article1, article2])
    expect(Article.permitted_by(@permissions, :show)).to eq([article1, article2])
  end

  it "fetches only the articles that are published" do
    block = Proc.new { |article| article.published == true }

    @permissions.allow_action(:articles, [:permitted_by, :show], &block)

    article1 = Article.create!(published: true)
    article2 = Article.create!(published: false)

    expect(@permissions).to allow_action(:articles, :show, article1)
    expect(@permissions).to_not allow_action(:articles, :show, article2)
    expect(Article.permitted_by(@permissions)).to eq([article1])
    expect(Article.permitted_by(@permissions, :show)).to eq([article1])
  end

  it "fetches any articles which are published or secret" do
    block = Proc.new { |article| (article.published == true) | (article.secret == true) }

    @permissions.allow_action(:articles, [:permitted_by, :show], &block)

    article1 = Article.create!(published: true,  secret: false)
    article2 = Article.create!(published: true,  secret: true)
    article3 = Article.create!(published: false, secret: true)
    article4 = Article.create!(published: false, secret: false)

    expect(@permissions).to allow_action(:articles, :show, article1)
    expect(@permissions).to allow_action(:articles, :show, article2)
    expect(@permissions).to allow_action(:articles, :show, article3)
    expect(@permissions).to_not allow_action(:articles, :show, article4)
    expect(Article.permitted_by(@permissions)).to eq([article1, article2, article3])
    expect(Article.permitted_by(@permissions, :show)).to eq([article1, article2, article3])
  end

  it "fetches only the articles that are published and not secret" do
    block = Proc.new { |article| (article.published == true) & (article.secret == false) }

    @permissions.allow_action(:articles, [:permitted_by, :show], &block)

    article1 = Article.create!(published: true,  secret: false)
    article2 = Article.create!(published: true,  secret: true)
    article3 = Article.create!(published: false, secret: true)
    article4 = Article.create!(published: false, secret: false)

    expect(@permissions).to allow_action(:articles, :show, article1)
    expect(@permissions).to_not allow_action(:articles, :show, article2)
    expect(@permissions).to_not allow_action(:articles, :show, article3)
    expect(@permissions).to_not allow_action(:articles, :show, article4)
    expect(Article.permitted_by(@permissions)).to eq([article1])
    expect(Article.permitted_by(@permissions, :show)).to eq([article1])
  end

  it "only reads comments for articles which are published" do
    block = Proc.new { article.published == true }

    @permissions.allow_action(:comments, :permitted_by, &block)

    comment1 = Comment.create!(article: Article.create!(published: true))
    comment2 = Comment.create!(article: Article.create!(published: false))

    @comments = Comment.joins(:article).permitted_by(@permissions)
    expect(@comments).to eq([comment1])

    @comments = Comment.joins{article}.permitted_by(@permissions)
    expect(@comments).to eq([comment1])
  end

  it "only reads comments for visible categories through articles" do
    block = Proc.new { article.category.visible == true }

    @permissions.allow_action(:comments, :permitted_by, &block)

    comment1 = Comment.create!(article: Article.create!(category: Category.create!(visible: true)))
    comment2 = Comment.create!(article: Article.create!(category: Category.create!(visible: false)))

    @comments = Comment.joins{article.category}.permitted_by(@permissions)
    expect(@comments).to eq([comment1])
  end

end
