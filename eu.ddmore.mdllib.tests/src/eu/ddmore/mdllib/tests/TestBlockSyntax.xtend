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
import eu.ddmore.mdllib.mdllib.Library
import eu.ddmore.mdllib.scoping.MdlLibLib
import org.junit.Test
import org.junit.runner.RunWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper

@RunWith(XtextRunner)
@InjectWith(MdlLibInjectorProvider)
class TestBlockSyntax {
	
	@Inject extension MdlLibLib
	
	@Inject extension ParseHelper<Library>
	@Inject	extension ValidationTestHelper

	@Test 
	def void testBlockDeclnSyntax() {
		val result = '''
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn, _listDefn+;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testBlockDeclnWithArgDefnSyntax() {
		val result = '''
			_block DATA_INPUT_VARIABLES (0, 1) _arguments level::int _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testBlockDeclnWith2ArgDefnSyntax() {
		val result = '''
			_block DATA_INPUT_VARIABLES (0, 1) _arguments level::int, another::real? _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testBlockDeclnMissingLimitsSyntax() {
		val result = '''
			_block DATA_INPUT_VARIABLES (, ) _statements (, ) _eqnDefn;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testObjectDeclnSyntax() {
		val result = '''
			_object dataObj;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testObjectContentDefns() {
		val result = '''
			_object dataObj "obj doc";
			_block DATA_INPUT_VARIABLES "block doc" (0, 1) _statements (0,) _listDefn;
			_block MODEL_PREDICTION (0, ) _statements (0,) _eqnDefn, _eqnDefn+, _listDefn;						
			_block DEQ (0, ) _statements (0,) _eqnDefn, _eqnDefn+, _listDefn;
			_container dataObj _has DATA_INPUT_VARIABLES, MODEL_PREDICTION;
			_container MODEL_PREDICTION _has DEQ; 			
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testBlockArgumentDefns() {
		val result = '''
			_block DATA_INPUT_VARIABLES "block doc" (0, 1) _arguments level::string "Variability level" _statements (,) _eqnDefn;
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