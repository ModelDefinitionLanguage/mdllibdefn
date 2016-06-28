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
class TestPropertyCollectionSyntax {
	
	@Inject extension MdlLibLib
	
	@Inject extension ParseHelper<Library>
	@Inject	extension ValidationTestHelper

	@Test 
	def void testSinglePropSyntax() {
		val result = '''
			_prop propOne::real "a prop";			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_prop propOne;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testFreePropSyntax() {
		val result = '''
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_prop _free;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testPropCollOnlySyntax() {
		val result = '''
			_prop propOne::real, propTwo::string;			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_prop propOne, propTwo?;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testPropCollAndListSyntax() {
		val result = '''
			_type testEnum _enum (foo, bar);
			_sublist aSubList "a sublist" _atts use::testEnum
				_sig (use);
			_list testList _atts use::testEnum, anAtt::aSubList, altAtt::real
			 	_sig (use, anAtt?),
			 		 (use, altAtt);
			 				
			_prop propOne::real, propTwo::string;			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_prop propOne, propTwo?
				_list testList;
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