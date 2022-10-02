capture program drop random_assign

program define random_assign

syntax, n(int) q(int) [noextra(numlist) skip(numlist)]
quietly {
local q_helper : di "-1"

clear
set obs `n'
gen group_number = _n
local q_count = 0

local skip_helper : di "-1"
local skip_count = 0
foreach i in `skip' {
	local skip_helper : di "`skip_helper'" ", " "`i'"
	local skip_count = `skip_count' + 1
}
local as_max = floor(`q' / (`n' - `skip_count'))
di `skip_helper'

forvalues i = 1/`as_max' {
	gen assigned_q`i' = .
	forvalues k = 1/`n' {
		if !inlist(`k', `skip_helper') {
			local q_random = round(runiform(1,`q'))
			while inlist(`q_random', `q_helper') {
				local q_random = round(runiform(1,`q'))
			}
			local q_helper : di "`q_helper'" ", " "`q_random'"
			replace assigned_q`i' = `q_random' if group_number == `k'
			local q_count = `q_count' + 1
			if (`q_count' == `q') {
				continue, break
			}
		}
		if (`q_count' == `q') {
				continue, break
		}
	}
}

local screener = `q' - (`n' - `skip_count') * `as_max'

if `screener' != 0 {
	local e_count = 0
	foreach i in `noextra' {
		local e_count = `e_count' + 1
	}
	local e_count_helper = `n' - `e_count' - `skip_count'
	while (`e_count_helper' < `screener') {
		noi di "The groups are not enough under current noextra condition"
		noi di "Please enter groups to be removed from noextra"
		noi di "Separated by space only" _request(remove)
		local remove_helper $remove
		local noextra2
		foreach i in `remove_helper' {
			local remove_helper2 : di "`remove_helper2'" "`i'" ", "
		}
		foreach i in `noextra' {
			if !inlist(`i', `remove_helper2' -999) {
				local noextra2 `noextra2' `i'
			}
		}
		local no2_count = 0
		foreach i in `noextra2' {
			local no2_count = `no2_count' + 1
			local no2_helper : di "`no2_helper'" "`i'" ", "
		}
		local e_count_helper = `n' - `no2_count' - `skip_count'
	}
	local name_helper = `as_max' + 1
	gen assigned_q`name_helper' = .
	forvalues i = 1 / `n' {
		if (!inlist(`i', `no2_helper' -999) & !inlist(`i', `skip_helper')) {
			local q_random = round(runiform(1,`q'))
			while inlist(`q_random', `q_helper') {
				local q_random = round(runiform(1,`q'))
			}
			local q_helper : di "`q_helper'" ", " "`q_random'"

			replace assigned_q`name_helper' = `q_random' if group_number == `i'
			local q_count = `q_count' + 1
			if `q_count' == `q' {
				continue, break
			}
		}
		if (`q_count' == `q') {
			continue, break
		}
	}
	
}
}
end
