package com.example.mall.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.mall.mapper.StatisticalMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class StatisticalService {
	
	@Autowired StatisticalMapper statisticalMapper;
	
	public Map<String, Object> getStatistical() {
		
	    List<Map<String, Object>> resultDailySales = statisticalMapper.selectDailySales(); // 하루 매출
	    List<Map<String, Object>> resultGenderRatio = statisticalMapper.selectGenderRatio(); // 남여 성비
	    
	    Map<String, Object> resultMap = new HashMap<>();
	    resultMap.put("getDailySales", resultDailySales.get(0));
	    resultMap.put("getGenderRatio", resultGenderRatio);
	    
	    return resultMap;  // 첫 번째 행 반환
	}

}
