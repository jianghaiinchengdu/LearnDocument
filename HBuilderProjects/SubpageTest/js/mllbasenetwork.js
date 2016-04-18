var basenetwork = new mllbasenetwork('json');

function mllbasenetwork(dataType) {
	
	var requestDataType = dataType
//	var header = {
//			'Access-Control-Allow-Headers': 'X-Requested-With',
//			'apikey': '2a4469adb23039b30b55b5970e34f5ac',
//			'Accept':'image/*'
//		}
		/**
		 * 请求数据
		 * @param {String}  url
		 * @param {JSONObject}  param
		 * @param {Boolean}  cache
		 * @param {Number}  timeout
		 * @param {Function}  success
		 * @param {Function}  failure
		 */
	this.get = function(url, param, cache, timeout, success, failure) {
			mui.ajax(url, {
				data: param, //请求参数
//				dataType: requestDataType, //服务器返回json格式数据
				type: 'get', //HTTP请求类型
				timeout: timeout, //超时时间设置为10秒；
				cache: cache, //是否缓存
				success: success, //成功回调
				error: failure //失败回调
//				headers: header
			});
		}
		/**
		 * POST请求数据
		 * @param {String}  url
		 * @param {JSONObject}  param
		 * @param {Boolean}  cache
		 * @param {Number}  timeout
		 * @param {Function}  success
		 * @param {Function}  failure
		 */
	this.post = function(url, param, cache, timeout, success, failure) {
		mui.ajax(url, {
			data: param, //请求参数
			dataType: requestDataType, //服务器返回json格式数据
			type: 'post', //HTTP请求类型
			timeout: timeout, //超时时间设置为10秒；
			cache: cache, //是否缓存
			success: success, //成功回调
			error: failure //失败回调
//			headers: header
		});
	}
}