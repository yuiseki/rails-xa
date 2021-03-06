# -*- coding: utf-8 -*-
class PlansController < ApplicationController
  caches_page :index
  def index
    now = Time.now
    if params[:date] and params[:date].size == '20080101'.size
      y = params[:date][0,4].to_i
      m = params[:date][4,2].to_i
      d = params[:date][6,2].to_i
      if params[:time]
        h = params[:time].to_i
        @now_time = DateTime.new(y,m,d,h)
        @end_time = @now_time + 3.hour
      else
        h = 0
        @now_time = DateTime.new(y,m,d,h)
        @end_time = @now_time + 24.hour
      end
    else
      y = 2008#now.year
      m = 12#now.month
      d = 31#now.day
      h = 20#now.hour - 1
      @now_time = DateTime.new(y,m,d,h)
      @end_time = @now_time + 12.hour
    end
    @plans = Plan.find(:all, :order => "start", :conditions => ["start between ? and ? ", @now_time, @end_time])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plans }
    end
  end

  def all
    @plans = Plan.find(:all, :order => "start")
    @now_time = DateTime.new(2008, 12, 31, 12)
    @end_time = now_time + 48.hour
    respond_to do |format|
      format.html { render :action => "index"}# index.html.erb
      format.xml  { render :xml => @plans }
    end
  end

  def yep2008
    @now_time = DateTime.new(2008, 12, 31, 12)
    @end_time = now_time + 48.hour
    @plans = Plan.find(:all, :order => "start", :conditions => ["start between ? and ? ", @now_time, @end_time])
    respond_to do |format|
      format.html { render :action => "index"}# index.html.erb
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

  def show
    @plan = Plan.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @plan }
    end
  end

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
