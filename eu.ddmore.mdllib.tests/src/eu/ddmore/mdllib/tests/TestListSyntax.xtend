/*******************************************************************************
 * Copyright (c) 2016 Pfizer Ltd.
 *
 * This file is part of the MDL Library.
 *
 * The MDL Library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * The MDL Library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with The MDL Library.  If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************/
package eu.ddmore.mdllib.tests

import com.google.inject.Inject
import eu.ddmore.mdllib.MdlLibInjectorProvider
import eu.ddmore.mdllib.mdllib.Library
import eu.ddmore.mdllib.scoping.MdlLibLib
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(MdlLibInjectorProvider)
class TestListSyntax {
	
	@Inject extension MdlLibLib
	
	@Inject extension ParseHelper<Library>
	@Inject	extension ValidationTestHelper

	@Test 
	def void testListDeclnWithKeyValSyntax() {
		val result = '''
			_type divUse _enum (covariate, amt, dv, dvid, cmt, mdv, idv, id, rate, ignore, varLevel, catCov, ss, ii, addl);
			_list covList _alt ::Real _atts use::divUse
				_sig (use);
			_list catCovList _atts use::divUse
				_cat use::Int
			 	_sig (use);
			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list _key=use divUse.covariate->covList, divUse.catCov->catCovList;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDeclnWithKeysSyntax() {
		val result = '''
			_type Real _real;
			_list list1 _atts att1::Real
				_sig (att1);
			_list list2 _atts att2::Real
			 	_sig (att2);
			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list _map list1.att1->list1, list2.att2->list2;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDecln2SigsSyntax() {
		val result = '''
			_list VarLevel 
				_atts use::Int , foo::Real, anot::String
				_sig (use, foo?), (anot, foo?);
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list VarLevel;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDecln2SigsWithKeyValSyntax() {
		val result = '''
			_list VarLevel
				_atts use::Int , foo::Real, anot::String
				_sig (use, foo?), (anot, foo?);
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list  VarLevel;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDeclnWithBlockOwners() {
		val result = '''
			_list VarLevel
				_atts type::Int , foo::Real, anot::String
				_sig (type, foo?), (anot, foo?);
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list VarLevel;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListFunctionRefSyntax() {
		val result = '''
			_list VarLevel
				_atts type::Int , foo::Reference[::Function(::Int,::String)::Real], bar::String
				_sig (type, foo?), (foo?, bar);
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list VarLevel;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDeclnWithSuperList() {
		val result = '''
			_list DerivSuper _super;
			_list myList _alt ::Deriv _extends DerivSuper
				_atts deriv::Real, foo::Reference[::Real], anot::String
				_sig (deriv, foo?), (anot, foo?)
				;
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list myList;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDeclnWithSuperListAndAltType() {
		val result = '''
			_list DerivSuper _super _alt ::Matrix[[::Real]];
			_list myList _alt ::Deriv _extends DerivSuper
				_atts deriv::Real, foo::Reference[::Real], anot::String
				_sig (deriv, foo?), (anot, foo?)
				;
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list myList;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDeclnWithCatMappings() {
		val result = '''
			_type divUse _enum (covariate, amt, dv, dvid, cmt, mdv, idv, id, rate, ignore, varLevel, catCov, ss, ii, addl);
			_list DerivSuper _super;
			_list VarLevel _alt ::Real _extends DerivSuper
				_atts use::divUse , foo::Real, anot::String
				_cat use::Int
				_sig (use, foo?), (anot, foo?)
				;
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list _key=use divUse.covariate->VarLevel;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDeclnWithRVAtt() {
		val result = '''
			_type divUse _enum (covariate, amt, dv, dvid, cmt, mdv, idv, id, rate, ignore, varLevel, catCov, ss, ii, addl);
			_type RandomVariable _rv;
			_list DerivSuper _super;
			_list VarLevel _alt ::Real _extends DerivSuper
				_atts use::divUse , foo::Real, anot::RandomVariable[::Real]
				_cat use::Int
				_sig (use, foo?), (anot, foo?)
				;
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list _key=use divUse.covariate->VarLevel;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	def private loadLibAndParse(CharSequence p) {
		p.parse(loadLibrary)
	}
	
	def private loadLibrary() {
		loadLib => [
			resources.forEach [
				contents.get(0).assertNoErrors
			]
		]
	}
}