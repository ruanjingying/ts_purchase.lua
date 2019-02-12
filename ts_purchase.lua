ngx.req.read_body()
local args = ngx.req.get_uri_args()
local op_type = args.op_type
local purchase_id = luuid.luuid24()
local company_id = args.company_id
local detail = args.detail
local demand_vol = args.demand_vol
local category = args.cate
local name = arge.name
local phone = args.phone
local company_name = args.company_name

-- 采购信息发布
local function ts_purchase_new()
	local data_json = ngx.req.get_body_data()         --获得post里面的数据
	local data = userutil.check_post_data(data_json)


	local sql = "insert into ts_purchase_list set company_id="  .. company_id .. ",detail="  .. datail .. ",demand_vol="  .. demand_vol .. ",category="  .. category .. ",purchase_id="  .. purchase_id .. ""
	local ts_purchase_list = userutil.query_common_user(sql)

end

-- 采购信息列表
local function ts_purchase_list()
	local token = args.token
--检查token格式是否正确
    if not userutil.is_token_valid(token)then
           userutil.exit(406,0,"105","token invalid",nil)
    end
	local user_id = userutil.get_uid_by_token(token)
    local sql = "select purchase_id, detail,demand_vol,category,name,phone,company_name from ts_purchase_list  where user_id="..user_id..""
	local ts_purchase_list = userutil.query_common_user(sql)

		local list = {}
		for k,v in pairs(ts_purchase_list) do
			local item = {}
			item["purchase_id"] = v["purchase_id"]
			item["detail"] = v["detail"]
			item["demand_vol"] = v["demand_vol"]
			item["category"] = v["category"]
			item["name"] = v["name"]
			item["phone"] = v["phone"]
			item["company_name"] = v["company_name"] 
			table.insert(list,item)
	    end
    
    userutil.exit(200, 1, "", "", list)
    end
	-- 
-- 采购信息列表删除
local function ts_purchase_list_delete()
	if not userutil.is_args_valid(1, purchase_id) then
		userutil.exit(406, 0, userconf.errcode.PARAMETER_INVALID, "param missing")
	end
	local sql = "delete from ts_purchase_list  where purchase_id=" .. purchase_id .. ""
	local ts_purchase_list = userutil.query_common_user(sql)
    nlog.dinfo("delet name sql:" .. sql)
    userutil.query_common_user(sql)		
end
    

  
   

local methods = {     ["purchase_new"] = ts_purchase_new,
["purchase_list"] = ts_purchase_list,     ["purchase_delete"] =
ts_purchase_list_delete, }

if op_type and methods[op_type] then
	local resp = methods[op_type]() or {}
	userutil.exit(200, 1, nil, nil, resp)
else
	userutil.exit(406, 0, userconf.errcode.PARAMETER_INVALID, "param op_type error")
end