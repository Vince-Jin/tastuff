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
	local noextra_count = 0
	foreach i in `noextra' {
		local noextra_count = `noextra_count' + 1
	}
	local noextra2 `noextra'
	if ((`n' - `noextra_count' - `skip_count') < `screener') {
		di "The question left is more than than the table that were not ecluded/skipped, please indicate tables to be removed from noextra, separated by space" _request(remove)
		local remove_helper $remove
		foreach i in `remove_helper' {
			local remove_helper2 : di "`remove_helper2'" ", " "`i'"
		}
		local noextra2
		foreach i in `noextra' {
			if !inlist(`i', `remove_helper2') {
				local noextra2 `noextra2' `i'
			}
		}
		local noextra_count = 0
		foreach i in `noextra2' {
			local noextra_count = 
		}
	}
	local name_helper = `as_max' + 1
	gen assigned_q`name_helper' = .
	local extra_max = `n' - `noextra'
	forvalues i = 1/`extra_max' {
		local id_helper = `noextra' + `i'
		if !inlist(`id_helper', `skip_helper') {
			local q_random = round(runiform(1,`q'))
			while inlist(`q_random', `q_helper') {
				local q_random = round(runiform(1,`q'))
			}
			local q_helper : di "`q_helper'" ", " "`q_random'"

			replace assigned_q`name_helper' = `q_random' if group_number == `id_helper'
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
