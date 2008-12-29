class PlansController < ApplicationController
  def index
    now_time = Time.now-60*60
    @plans = Plan.find(:all, :order => "start", :conditions => ["start >= ?",now_time])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plans }
    end
  end

  def edit
    @plan = Plan.find(params[:id])
  end

  def update
    @plan = Plan.find(params[:id])
    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        flash[:notice] = '予定更新完了'
        format.html { redirect_to(:controller=>"/") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  #def show
  #  @plan = Plan.find(params[:id])
#
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.xml  { render :xml => @plan }
  #  end
  #end

  #def new
  #  @plan = Plan.new
#
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.xml  { render :xml => @plan }
  #  end
  #end

  #def create
  #  @plan = Plan.new(params[:plan])
#
  #  respond_to do |format|
  #    if @plan.save
  #      flash[:notice] = 'Plan was successfully created.'
  #      format.html { redirect_to(@plan) }
  #      format.xml  { render :xml => @plan, :status => :created, :location => @plan }
  #    else
  #      format.html { render :action => "new" }
  #      format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  #def destroy
  #  @plan = Plan.find(params[:id])
  #  @plan.destroy
#
  #  respond_to do |format|
  #    format.html { redirect_to(plans_url) }
  #    format.xml  { head :ok }
  #  end
  #end
end