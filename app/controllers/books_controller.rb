class BooksController < ApplicationController
  load_and_authorize_resource

  before_action :set_order_item, only: %i[index show update]
  before_action :set_categories, only: %i[index show]
  before_action :set_current_category, only: %i[index]
  before_action :set_sort_options, only: %i[index]

  def index
    @books = if @current_category.id
               Book.by_category(@current_category.id).order(@sort_option).page params[:page]
             else
               Book.order(@sort_option).page params[:page]
             end
  end

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews.approved
  end

  def update
    @book = Book.find(params[:id])
    @book.update_attributes(book_params)

    render :show
  end

  private

  def book_params
    params.require(:book).permit(:title, :price, :publication_year, :materials,
                                 :description, :height, :width, :depth,
                                 :cover, :cover_cache,
                                 { images: [] }, :images_cache)
  end

  def set_order_item
    @order_item = OrderItem.new
  end

  def set_categories
    @categories = Category.order('name')
  end

  def set_current_category
    category_id = params[:category_id]
    @current_category = if category_id && Category.ids.include?(category_id.to_i)
                          @categories.find(category_id)
                        else
                          Category.new(id: nil, name: 'All')
                        end
  end

  def set_sort_options
    if params[:sort_by] && SORT_OPTIONS.keys.include?(params[:sort_by].to_sym)
      @sort_name   = SORT_OPTIONS[params[:sort_by].to_sym][:name]
      @sort_option = SORT_OPTIONS[params[:sort_by].to_sym][:query]
    else
      @sort_name   = SORT_OPTIONS[:newest_first][:name]
      @sort_option = SORT_OPTIONS[:newest_first][:query]
    end
  end
end
