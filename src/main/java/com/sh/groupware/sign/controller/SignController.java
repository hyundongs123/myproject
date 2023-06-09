package com.sh.groupware.sign.controller;

import java.time.Duration;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.RowBounds;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.sh.groupware.dayOff.model.dto.DayOff;
import com.sh.groupware.dayOff.model.service.DayOffService;
import com.sh.groupware.emp.model.dto.Emp;
import com.sh.groupware.emp.model.service.EmpService;
import com.sh.groupware.report.model.dto.YN;
import com.sh.groupware.sign.model.dto.DayOffForm;
import com.sh.groupware.sign.model.dto.DayOffType;
import com.sh.groupware.sign.model.dto.ProductForm;
import com.sh.groupware.sign.model.dto.ResignationForm;
import com.sh.groupware.sign.model.dto.Sign;
import com.sh.groupware.sign.model.dto.SignEntity;
import com.sh.groupware.sign.model.dto.SignStatus;
import com.sh.groupware.sign.model.dto.SignStatusDetail;
import com.sh.groupware.sign.model.dto.SignType;
import com.sh.groupware.sign.model.dto.Status;
import com.sh.groupware.sign.model.dto.TripForm;
import com.sh.groupware.sign.model.service.SignService;
import com.sh.groupware.workingManagement.model.dto.WorkingManagement;
import com.sh.groupware.workingManagement.model.service.WorkingManagementService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/sign")
public class SignController {
	
	@Autowired
	private SignService signService;
	
	@Autowired
	private EmpService empService;
	
	@Autowired
	private WorkingManagementService workingService;
	
	@Autowired
	private DayOffService dayOffService;

	@GetMapping("/sign.do")
	public String sign(Model model, Authentication authentication) {
		String empId = ((Emp) authentication.getPrincipal()).getEmpId();
		
		// 내가 작성한 결재 완료 목록
		List<Sign> myCreateSignListComlete = signService.findByMyCreateSignListComlete(empId);
		// 내가 작성한 결재 중인 목록
		List<Sign> myCreateSignListIng = signService.findByMyCreateSignListIng(empId);
		// 내가 결재해야 하는 목록
		List<Sign> mySignList = signService.findByMySignList(empId);
		
		model.addAttribute("myCreateSignListIng", myCreateSignListIng);
		model.addAttribute("myCreateSignListComlete", myCreateSignListComlete);
		model.addAttribute("mySignList", mySignList);
		
		return "sign/signHome";
	} // sign() end
	
	
	/**
	 * 연차 및 출장 확정된 날짜 목록
	 * 
	 * @param empId
	 * @return
	 */
	public List<Map<String, Object>> noDateList(String empId) {
		List<Map<String, Object>> noDateList = new ArrayList<>();
		
		List<Map<String, Object>> list = workingService.findByEmpIdNoDate(empId);
		
		if (list.size() > 0) {
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
			for (Map<String, Object> map : list) {
				Map<String, Object> param = new HashMap<>();
				param.put("state", map.get("STATE"));
				String reg = String.valueOf(map.get("REG_DATE"));
				log.debug("reg = {}", reg);
				
				LocalDate regDate = LocalDate.parse(reg, formatter);
				log.debug("regDate = {}", regDate);
				
				param.put("reg_date", regDate);
				noDateList.add(param);
			}
		}
		
		return noDateList;
	} // noDateList() end
	
	
	/**
	 * 연차 및 출장 신청 중인 날짜 목록
	 * 
	 * @param empId
	 * @return
	 */
	public List<Map<String, Object>> toBeNoDateList(String empId) {
		List<Map<String, Object>> toBeNoDateList = new ArrayList<>();
		
		// 예정된 연차 및 반차 날짜
		List<Map<String, Object>> toBeNoDateDayOffList = signService.findByEmpIdToBeNoDateDayOff(empId);
		log.debug("toBeNoDateDayOffList = {}", toBeNoDateDayOffList);
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
		if (toBeNoDateDayOffList.size() > 0) {
			for (Map<String, Object> map : toBeNoDateDayOffList) {
				String start = String.valueOf(map.get("START_DATE"));
				String end = String.valueOf(map.get("END_DATE"));
				log.debug("start = {}, end = {}", start, end);
				
				LocalDate startDate = LocalDate.parse(start, formatter);
				LocalDate endDate = LocalDate.parse(end, formatter);
				log.debug("startDate = {}, endDate = {}", startDate, endDate);
				
				int betweenDays = (int) Duration.between(startDate.atStartOfDay(), endDate.atStartOfDay()).toDays();
				log.debug("betweenDays = {}", betweenDays);
				
				for (int j = 0; j <= betweenDays; j++) {
					Map<String, Object> param = new HashMap<>();
					switch (String.valueOf(map.get("TYPE"))) {
					case "D":
						param.put("state", "연차 예정");
						break;
					case "H":
						param.put("state", "반차 예정");
						break;
					}
					
					param.put("reg_date", startDate.plusDays(j));
					toBeNoDateList.add(param);
				}
				
			}
		} // 예정된 연차 및 반차 날짜 있는 경우
		
		
		// 예정된 출장 날짜
		List<Map<String, Object>> toBeNoDateTripList = signService.findByEmpIdToBeNoDateTrip(empId);
		log.debug("toBeNoDateTripList = {}", toBeNoDateTripList);
		
		if (toBeNoDateTripList.size() > 0) {
			for (Map<String, Object> map : toBeNoDateTripList) {
				String start = String.valueOf(map.get("START_DATE"));
				String end = String.valueOf(map.get("END_DATE"));
				log.debug("start = {}, end = {}", start, end);
				
				LocalDate startDate = LocalDate.parse(start, formatter);
				LocalDate endDate = LocalDate.parse(end, formatter);
				log.debug("startDate = {}, endDate = {}", startDate, endDate);
				
				int betweenDays = (int) Duration.between(startDate.atStartOfDay(), endDate.atStartOfDay()).toDays();
				log.debug("betweenDays = {}", betweenDays);
				
				for (int j = 0; j <= betweenDays; j++) {
					Map<String, Object> param = new HashMap<>();
					param.put("state", "출장 예정");
					param.put("reg_date", startDate.plusDays(j));
					toBeNoDateList.add(param);
				}
			}
		}// 예정된 출장 날짜 있는 경우
		
		return toBeNoDateList;
	} // toBeNoDateList() end
	
	
	/**
	 * 해당 출장 또는 연차 날짜 제외한 나머지 신청중인 날짜 목록
	 * 
	 * @param empId
	 * @param no
	 * @param type
	 * @return
	 */
	public List<Map<String, Object>> thisNotoBeNoDateList(String empId, String no, String type) {
		List<Map<String, Object>> toBeNoDateList = new ArrayList<>();
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
		Map<String, Object> mapParam = new HashMap<>();
		mapParam.put("empId", empId);
		mapParam.put("no", no);
		
		// 예정된 연차 및 반차 날짜
		List<Map<String, Object>> toBeNoDateDayOffList = new ArrayList<>();
		if ("D".equals(type)) {
			toBeNoDateDayOffList = signService.findByEmpIdSignNoToBeNoDateDayOff(mapParam);
		} else {
			toBeNoDateDayOffList = signService.findByEmpIdToBeNoDateDayOff(empId);
		}
		log.debug("toBeNoDateDayOffList = {}", toBeNoDateDayOffList);
		
		if (toBeNoDateDayOffList.size() > 0) {
			for (Map<String, Object> map : toBeNoDateDayOffList) {
				String start = String.valueOf(map.get("START_DATE"));
				String end = String.valueOf(map.get("END_DATE"));
				log.debug("start = {}, end = {}", start, end);
				
				LocalDate startDate = LocalDate.parse(start, formatter);
				LocalDate endDate = LocalDate.parse(end, formatter);
				log.debug("startDate = {}, endDate = {}", startDate, endDate);
				
				int betweenDays = (int) Duration.between(startDate.atStartOfDay(), endDate.atStartOfDay()).toDays();
				log.debug("betweenDays = {}", betweenDays);
				
				for (int j = 0; j <= betweenDays; j++) {
					Map<String, Object> param = new HashMap<>();
					switch (String.valueOf(map.get("TYPE"))) {
					case "D":
						param.put("state", "연차 예정");
						break;
					case "H":
						param.put("state", "반차 예정");
						break;
					}
					
					param.put("reg_date", startDate.plusDays(j));
					toBeNoDateList.add(param);
				}
				
			}
		}
		
		// 예정된 출장 날짜
		List<Map<String, Object>> toBeNoDateTripList = new ArrayList<>();
		if ("T".equals(type)) {
			toBeNoDateTripList = signService.findByEmpIdSignNoToBeNoDateTrip(mapParam);
		} else {
			toBeNoDateTripList = signService.findByEmpIdToBeNoDateTrip(empId);
		}
		log.debug("toBeNoDateTripList = {}", toBeNoDateTripList);
		
		if (toBeNoDateTripList.size() > 0) {
			for (Map<String, Object> map : toBeNoDateTripList) {
				String start = String.valueOf(map.get("START_DATE"));
				String end = String.valueOf(map.get("END_DATE"));
				log.debug("start = {}, end = {}", start, end);
				
				LocalDate startDate = LocalDate.parse(start, formatter);
				LocalDate endDate = LocalDate.parse(end, formatter);
				log.debug("startDate = {}, endDate = {}", startDate, endDate);
				
				int betweenDays = (int) Duration.between(startDate.atStartOfDay(), endDate.atStartOfDay()).toDays();
				log.debug("betweenDays = {}", betweenDays);
				
				for (int j = 0; j <= betweenDays; j++) {
					Map<String, Object> param = new HashMap<>();
					param.put("state", "출장 예정");
					param.put("reg_date", startDate.plusDays(j));
					toBeNoDateList.add(param);
				}
			}
		}
		
		return toBeNoDateList;
	} // thisNotoBeNoDateList() end
	
	
	@GetMapping("/form/dayOff.do")
	public String dayOff(Authentication authentication, Model model) {
		String empId = ((Emp) authentication.getPrincipal()).getEmpId();
		double leaveCount = signService.findByEmpIdTotalCount(empId);
		
		// 확정된 연차 및 반차, 출장 날짜
		List<Map<String, Object>> noDateList = noDateList(empId);
		log.debug("noDateList = {}", noDateList);
		
		// 예정된 연차 및 반차, 출장 날짜
		List<Map<String, Object>> toBeNoDateList = toBeNoDateList(empId);
		log.debug("toBeNoDateList = {}", toBeNoDateList);
		
		model.addAttribute("noDateList", noDateList);
		model.addAttribute("toBeNoDateList", toBeNoDateList);
		model.addAttribute("leaveCount", leaveCount);
		return "sign/form/dayOffForm";
	} // dayOff() end
	
	
	@PostMapping("/dayOffCreate.do")
	public String dayOffCreate(DayOffForm dayOffForm, @RequestParam String emergency, Authentication authentication) {
		log.debug("dayOffForm = {}", dayOffForm);
		log.debug("emergency = {}", emergency);

		Emp loginMember = (Emp) authentication.getPrincipal();
		SignEntity sign = new SignEntity(
			null, 
			loginMember.getEmpId(), 
			loginMember.getDeptCode(), 
			loginMember.getJobCode(), 
			SignType.D, 
			null, 
			YN.valueOf(emergency),
			null
		);
		int result = signService.insertSignDayOffForm(dayOffForm, sign);
		
		return "redirect:/sign/sign.do";
	} // dayOffCreate() end
	
	
	// 제출한 결재 양식 수정 시 결재선도 처음부터
	public int formUpdateSignStatusUpdate(String signNo) {
		List<SignStatus> signStatusList = signService.findBySignNoSignStatusList(signNo);
		
		int result = 0;
		Map<String, Object> param = new HashMap<>();
		
		for (SignStatus signStatus : signStatusList) {
			param.put("signNo", signStatus.getSignNo());
			param.put("empId", signStatus.getEmpId());
			if (signStatus.getSignOrder() == 1) {
				param.put("status", "W");
				result = signService.updateSignStatus(param);
			} else {
				param.put("status", "S");
				result = signService.updateSignStatus(param);
			}
		}
		
		return result;
	} // formUpdateSignStatusUpdate() end
	
	
	@PostMapping("/dayOffUpdate.do")
	public String dayOffUpdate(DayOffForm dayOff) {
		log.debug("dayOff = {}", dayOff);
		
		int result = signService.updateDayOffForm(dayOff);
		result = formUpdateSignStatusUpdate(dayOff.getSignNo());
		
		return "redirect:/sign/signDetail.do?no=" + dayOff.getSignNo() + "&type=D";
	} // dayOffUpdate() end
	
	
	@GetMapping("/form/trip.do")
	public String trip(Authentication authentication, Model model) {
		String empId = ((Emp) authentication.getPrincipal()).getEmpId();
		
		// 확정된 연차 및 반차, 출장 날짜
		List<Map<String, Object>> noDateList = noDateList(empId);
		log.debug("noDateList = {}", noDateList);
		
		// 예정된 연차 및 반차, 출장 날짜
		List<Map<String, Object>> toBeNoDateList = toBeNoDateList(empId);
		log.debug("toBeNoDateList = {}", toBeNoDateList);
		
		model.addAttribute("noDateList", noDateList);
		model.addAttribute("toBeNoDateList", toBeNoDateList);
		return "sign/form/tripForm";
	} // trip() end
	
	
	@PostMapping("/tripCreate.do")
	public String tripCreate(TripForm tripForm, @RequestParam String emergency, Authentication authentication) {
		log.debug("tripForm = {}", tripForm);

		Emp loginMember = (Emp) authentication.getPrincipal();
		SignEntity sign = new SignEntity(
			null, 
			loginMember.getEmpId(), 
			loginMember.getDeptCode(), 
			loginMember.getJobCode(), 
			SignType.T, 
			null, 
			YN.valueOf(emergency),
			null
		);
		
		int result = signService.insertSignTripForm(tripForm, sign);
		
		return "redirect:/sign/sign.do";
	} // tripCreate() end
	
	
	@PostMapping("/tripUpdate.do")
	public String tripUpdate(TripForm trip) {
		log.debug("trip = {}", trip);
		
		int result = signService.updateTripForm(trip);
		result = formUpdateSignStatusUpdate(trip.getSignNo());
		
		return "redirect:/sign/signDetail.do?no=" + trip.getSignNo() + "&type=T";
	} // tripUpdate() end
	
	
	@GetMapping("/form/product.do")
	public String product() {
		return "sign/form/productForm";
	} // product() end
	
	
	@PostMapping("/productCreate.do")
	public String productCreate(ProductForm productForm, @RequestParam String emergency, Authentication authentication) {
		log.debug("productForm = {}", productForm);
		
		Emp loginMember = (Emp) authentication.getPrincipal();
		SignEntity sign = new SignEntity(
			null, 
			loginMember.getEmpId(), 
			loginMember.getDeptCode(), 
			loginMember.getJobCode(), 
			SignType.P, 
			null, 
			YN.valueOf(emergency),
			null
		);
		
		int result = 0;
		String signNo = signService.insertSign(sign);
		sign.setNo(signNo);
		List<ProductForm> productFormList = productForm.getProductFormList();
		for (ProductForm product : productFormList) {
			product.setSignNo(signNo);
			log.debug("product = {}", product);
			if (product.getName() != "")
				result = signService.insertProductForm(product);
		}
		
		return "redirect:/sign/sign.do";
	} // productCreate() end
	
	
	@PostMapping("/productUpdate.do")
	public String productUpdate(ProductForm productForm) {
		log.debug("productForm = {}", productForm);
		
		int result = 0;
		String signNo = productForm.getSignNo();
		
		List<ProductForm> productFormList = productForm.getProductFormList();
		for (ProductForm product : productFormList) {
			product.setSignNo(signNo);
			log.debug("product = {}", product);
			
			if (product.getName() != "") {
				if (product.getNo() != null)
					result = signService.updateProductForm(product);
				else
					result = signService.insertProductForm(product);
			}
			
			result = formUpdateSignStatusUpdate(product.getSignNo());
		}
		
		return "redirect:/sign/signDetail.do?no=" + signNo + "&type=P";
	} // productUpdate() end
	
	
	@GetMapping("/form/resignation.do")
	public String resignation() {
		return "sign/form/resignationForm";
	} // resignation() end
	
	
	@PostMapping("/resignationCreate.do")
	public String resignationCreate(ResignationForm resignation, @RequestParam String emergency, Authentication authentication) {
		log.debug("resignationForm = {}", resignation);
		
		Emp loginMember = (Emp) authentication.getPrincipal();
		SignEntity sign = new SignEntity(
			null, 
			loginMember.getEmpId(), 
			loginMember.getDeptCode(), 
			loginMember.getJobCode(), 
			SignType.R, 
			null, 
			YN.valueOf(emergency),
			null
		);
		int result = signService.insertSignResignationForm(resignation, sign);
		
		return "redirect:/sign/sign.do";
	} // resignationCreate() end
	
	
	@PostMapping("/resignationUpdate.do")
	public String resignationUpdate(ResignationForm resignation) {
		log.debug("resignation = {}", resignation);
		
		int result = signService.updateResignationForm(resignation);
		result = formUpdateSignStatusUpdate(resignation.getSignNo());
		
		return "redirect:/sign/signDetail.do?no=" + resignation.getSignNo() + "&type=R";
	} // resignationUpdate() end
	
	
	@GetMapping("/signDetail.do")
	public String signDetail(@RequestParam String no, @RequestParam String type, Model model) {
		log.debug("no = {}, type = {}", no, type);
		
		Sign sign = signService.findByNoSign(no);
		
		model.addAttribute("sign", sign);
		
		if ("D".equals(type)) {
			double leaveCount = signService.findByEmpIdTotalCount(sign.getEmpId());
			log.debug("leaveCount = {}", leaveCount);
			
			DayOffForm dayOff = signService.findBySignNoDayOffForm(no);

			// 확정된 연차 및 반차, 출장 날짜
			List<Map<String, Object>> noDateList = noDateList(sign.getEmpId());
			log.debug("noDateList = {}", noDateList);
			
			// 예정된 연차 및 반차, 출장 날짜
			List<Map<String, Object>> toBeNoDateList = thisNotoBeNoDateList(sign.getEmpId(), no, type);
			log.debug("toBeNoDateList = {}", toBeNoDateList);
			
			model.addAttribute("dayOff", dayOff);
			model.addAttribute("leaveCount", leaveCount);
			model.addAttribute("noDateList", noDateList);
			model.addAttribute("toBeNoDateList", toBeNoDateList);
			return "sign/detail/dayOffDetail";
		} // 연차신청서
		
		if ("T".equals(type)) {
			TripForm trip = signService.findBySignNoTripForm(no);
			
			// 확정된 연차 및 반차, 출장 날짜
			List<Map<String, Object>> noDateList = noDateList(sign.getEmpId());
			log.debug("noDateList = {}", noDateList);
			
			// 예정된 연차 및 반차, 출장 날짜
			List<Map<String, Object>> toBeNoDateList = thisNotoBeNoDateList(sign.getEmpId(), no, type);
			log.debug("toBeNoDateList = {}", toBeNoDateList);
			
			model.addAttribute("trip", trip);
			model.addAttribute("noDateList", noDateList);
			model.addAttribute("toBeNoDateList", toBeNoDateList);
			return "sign/detail/tripDetail";
		} // 출장신청서
		
		if ("P".equals(type)) {
			List<ProductForm> productList = signService.findBySignNoProductForm(no);
			log.debug("productList = {}", productList);
			model.addAttribute("productList", productList);
			return "sign/detail/productDetail";
		} // 비품신청서
		
		if ("R".equals(type)) {
			ResignationForm resignation = signService.findBySignNoResignationForm(no);
			model.addAttribute("resignation", resignation);
			return "sign/detail/resignationDetail";
		} // 사직서
		
		return "sign/signHome";
	} // signDetail() end
	
	
	@PostMapping("/deleteSign.do")
	public String signDelete(@RequestParam String no, @RequestParam String type, Authentication authentication) {
		log.debug("no = {}, type = {}", no, type);
		
		String form = null;
		
		switch (type) {
		case "D":
			form = "dayOffForm";
			break;
		case "T":
			form = "tripForm";
			break;
		case "P":
			form = "productForm";
			break;
		case "R":
			form = "resignationForm";
			break;
		}
		
		Map<String, Object> param = new HashMap<>();
		param.put("no", no);
		param.put("form", form);
		
		int result = signService.deleteOneSign(param);
		
		return "redirect:/sign/sign.do";
	} // signDelete() end
	
	
	@PostMapping("/signStatusUpdate.do")
	public String signStatusUpdate(SignStatus signStatus) {
		log.debug("signStatus = {}", signStatus);
		int result = 0;
		
		Sign sign = signService.findByNoSign(signStatus.getSignNo());
		log.debug("sign = {}", sign);
		List<SignStatusDetail> signStatusList = sign.getSignStatusList();
		log.debug("signStatusList = {}", signStatusList);
		
		for (int i = 0; i < signStatusList.size(); i++) {
			if (signStatus.getEmpId().equals(signStatusList.get(i).getEmpId())) {
				// 내 결제 상태 업데이트
				result = signService.updateMySignStatus(signStatus);
				
				// 결재상태가 반려인 경우
				if (Status.R == signStatus.getStatus()) {
					result = signService.updateSignComplete(sign.getNo());
				} // if end
				
				// 내가 마지막 결재자인 경우
				if (i == signStatusList.size() - 1) {
					result = signService.updateSignComplete(sign.getNo());

					WorkingManagement working = new WorkingManagement();
					
					// 결재 양식에 따라 해당 테이블 업데이트
					switch (sign.getType()) {
					case D:
						DayOffForm dayOffForm = signService.findBySignNoDayOffForm(sign.getNo());
						log.debug("dayOffForm = {}", dayOffForm);
						double leaveCount = signService.findByEmpIdTotalCount(sign.getEmpId());
						log.debug("leaveCount = {}", leaveCount);
						
						DayOff dayOff = new DayOff(
							null, 
							dayOffForm.getNo(),
							sign.getEmpId(), 
							dayOffForm.getStartDate().getYear(),
							dayOffForm.getStartDate(),
							dayOffForm.getEndDate(),
							dayOffForm.getCount(),
							leaveCount - dayOffForm.getCount(),
							null
						);
						log.debug("dayOff = {}", dayOff);
						
						working.setEmpId(sign.getEmpId());
						
						if (dayOffForm.getType() == DayOffType.D) {
							working.setState("연차");
							working.setDayWorkTime(28800000);
							
							for (int d = 0; d < dayOffForm.getCount(); d++) {								
								working.setRegDate(dayOffForm.getStartDate().plusDays(d));
								result = workingService.insertRegDateState(working);
							}
						} else {
							working.setState("반차");
							working.setDayWorkTime(14400000);
							working.setRegDate(dayOffForm.getStartDate());
							result = workingService.insertRegDateState(working);
						}
						
						result = dayOffService.insertDayOff(dayOff);
						break;
					case T:
						TripForm trip = signService.findBySignNoTripForm(sign.getNo());
						log.debug("trip = {}", trip);
						
						working.setState("출장");
						working.setEmpId(sign.getEmpId());
						working.setDayWorkTime(28800000);
						
						int betweenDays = (int) Duration.between(trip.getStartDate().atStartOfDay(), trip.getEndDate().atStartOfDay()).toDays();
						log.debug("betweenDays = {}", betweenDays);
						
						working.setRegDate(trip.getStartDate());
						result = workingService.insertRegDateState(working);
						
						if (betweenDays > 1) {
							for (int j = 1; j <= betweenDays; j++) {
								working.setRegDate(trip.getStartDate().plusDays(j));
								result = workingService.insertRegDateState(working);
							}
						}
						
						break;
					case R:
						ResignationForm resignation = signService.findBySignNoResignationForm(sign.getNo());
						log.debug("resignation = {}", resignation);
						
						Map<String, Object> param = new HashMap<>();
						param.put("endDate", resignation.getEndDate());
						param.put("empId", sign.getEmpId());
						
						result = empService.updateQuit(param);
						break;
					} // switch end
					
				} // if end
				// 내가 마지막 결재자가 아닌 경우
				else {
					// 결재인 경우에만 다음 결재자 결재 상태 업데이트
					if (Status.C == signStatus.getStatus()) {
						result = signService.updateNextSignStatus(signStatusList.get(i + 1).getNo());
					} // if end
				} // else end
				
			} // if end
		} // for end

		return "redirect:/sign/sign.do";
	} // signStatusUpdate() end
	
	
	@GetMapping("/signStatus.do")
	public String signStatus(String status, @RequestParam(defaultValue = "1") int cpage, Model model, Authentication authentication) {
		log.debug("status = {}", status);
		
		String empId = ((Emp) authentication.getPrincipal()).getEmpId();
		
		Map<String, Object> param = new HashMap<>();
		param.put("empId", empId);
		
		// 페이징처리
		int limit = 7;
		int offset = (cpage - 1) * limit; 
		RowBounds rowBounds = new RowBounds(offset, limit);
		log.debug("rowBounds = {}", rowBounds);
		
		switch (status) {
		// 결재 대기 문서
		case "W":
			String[] statusWH = {"W", "H"};
			param.put("inStatus", statusWH);
			break;
		// 결재 예정 문서
		case "S":
			String[] statusS = {"S"};
			param.put("inStatus", statusS);
			break;
		// 결재 수신 문서
		case "C":
			String[] statusC = {"C", "R"};
			param.put("inStatus", statusC);
			break;
		} // switch end
		
		// 내가 결재한(할) 모든 목록
		List<Sign> mySignStatusList = signService.findByEmpIdMySignStatus(param, rowBounds);
		
		int totalCount = signService.selectMySignStatusCount(param);
		
	    // 총 페이지 수 계산
	    int totalPage = (int) Math.ceil((double) totalCount / limit);
	    log.debug("totalPage = {}", totalPage);

	    // 시작 페이지와 끝 페이지 계산
	    int startPage = ((cpage - 1) / 10) * 10 + 1; // 10 페이지씩 묶어서 보여줌
	    int endPage = Math.min(startPage + 9, totalPage);
	    
	    model.addAttribute("currentPage", cpage);
	    model.addAttribute("startPage", startPage);
	    model.addAttribute("endPage", endPage);
	    model.addAttribute("totalPage", totalPage);
	    model.addAttribute("mySignStatusList", mySignStatusList);
		
		return "sign/signStatus";
	} // signStatus() end
	
	
	@GetMapping("/signUpdate.do")
	public String signUpdate(@RequestParam String no, @RequestParam String type, Model model) {
		log.debug("no = {}, type = {}", no, type);
		
		Sign sign = signService.findByNoSign(no);
		
		model.addAttribute("sign", sign);
		
		if ("D".equals(type)) {
			double leaveCount = signService.findByEmpIdTotalCount(sign.getEmpId());
			log.debug("leaveCount = {}", leaveCount);
			DayOffForm dayOff = signService.findBySignNoDayOffForm(no);
			model.addAttribute("dayOff", dayOff);
			model.addAttribute("leaveCount", leaveCount);
			return "sign/update/dayOffUpdate";
		} // 연차신청서
		
		if ("T".equals(type)) {
			TripForm trip = signService.findBySignNoTripForm(no);
			model.addAttribute("trip", trip);
			return "sign/update/tripUpdate";
		} // 출장신청서
		
		if ("P".equals(type)) {
			List<ProductForm> productList = signService.findBySignNoProductForm(no);
			log.debug("productList = {}", productList);
			model.addAttribute("productList", productList);
			return "sign/update/productUpdate";
		} // 비품신청서
		
		if ("R".equals(type)) {
			ResignationForm resignation = signService.findBySignNoResignationForm(no);
			model.addAttribute("resignation", resignation);
			return "sign/update/resignationUpdate";
		} // 사직서
		
		return "sign/signHome";
	} // signUpdate() end
	
	
	@GetMapping("/mySign.do")
	public String mySign(@RequestParam String status, Authentication authentication, Model model) {
		log.debug("status = {}", status);
		
		String empId = ((Emp) authentication.getPrincipal()).getEmpId();
		
		List<Sign> myCreateSignList;
		
		if ("end".equals(status)) {
			// 내가 작성한 결재 완료 목록
			myCreateSignList = signService.findByMyCreateSignListComlete(empId);
		} else {
			// 내가 작성한 결재 중인 목록
			myCreateSignList = signService.findByMyCreateSignListIng(empId);
		}
		
		model.addAttribute("myCreateSignList", myCreateSignList);
		return "sign/mySign";
	} // mySign() end
	
} // class end
