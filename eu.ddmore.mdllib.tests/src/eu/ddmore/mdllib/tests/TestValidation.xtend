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
import eu.ddmore.mdllib.mdllib.MdlLibPackage
import eu.ddmore.mdllib.scoping.MdlLibLib
import eu.ddmore.mdllib.validation.MdlLibValidator
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import org.eclipse.xtext.diagnostics.Diagnostic
import org.junit.Ignore

@RunWith(XtextRunner)
@InjectWith(MdlLibInjectorProvider)
class TestValidation {
	
	@Inject extension MdlLibLib
	
	@Inject extension ParseHelper<Library>
	@Inject	extension ValidationTestHelper

	@Test 
	def void testBlockKeyDefinitionOK() {
		val result = '''
			_type divUse _enum (covariate, amt, dv, dvid, cmt, mdv, idv, id, rate, ignore, varLevel, catCov, ss, ii, addl);
			_list covList _alt ::real _atts use::divUse
				_sig (use);
			_list catCovList _atts use::divUse
				_cat use::int
			 	_sig (use);
			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list _key=use divUse.covariate->covList, divUse.catCov->catCovList;
		'''.loadLibAndParse

		result.assertNoErrors(Diagnostic.SYNTAX_DIAGNOSTIC)
		result.assertNoErrors
	}

	@Test 
	def void testInvalidBlockKeyDefinitionNotSameKeyValueType() {
		val result = '''
			_type divUse _enum (covariate, catCov);
			_type divUse2 _enum (covariate, catCov);
			_list covList _alt ::real _atts use::divUse
				_sig (use);
			_list catCovList _atts use::divUse2
				_cat use::int
			 	_sig (use);
			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list _key=use divUse2.covariate->covList, divUse.catCov->catCovList;
		'''.loadLibAndParse

		result.assertNoErrors(Diagnostic.SYNTAX_DIAGNOSTIC)
		result.assertError(MdlLibPackage.eINSTANCE.blockDefinition, MdlLibValidator::MALFORMED_BLOCK_DEFINITION, "Mapped list key values must be of the same type.")
	}

	@Test 
	def void testInvalidBlockKeyDefinitionWrongKey() {
		val result = '''
			_type divUse _enum (covariate, catCov);
			_list covList _alt ::real _atts use::divUse, tst::real
				_sig (use, tst);
			_list catCovList _atts use::divUse, tst::real
				_cat use::int
			 	_sig (use, tst);
			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list _key=tst divUse.covariate->covList, divUse.catCov->catCovList;
		'''.loadLibAndParse

		result.assertNoErrors(Diagnostic.SYNTAX_DIAGNOSTIC)
		result.assertError(MdlLibPackage.eINSTANCE.blockDefinition, MdlLibValidator::MALFORMED_BLOCK_DEFINITION,
							"Mapped value 'covariate' must have the same type as the key 'tst'.")
		result.assertError(MdlLibPackage.eINSTANCE.blockDefinition, MdlLibValidator::MALFORMED_BLOCK_DEFINITION,
							"Mapped value 'catCov' must have the same type as the key 'tst'.")
	}

	@Test 
	def void testInvalidBlockKeyDefinitionKeyMissing() {
		val result = '''
			_type divUse _enum (covariate, catCov);
			_list covList _alt ::real _atts use::divUse, tst::real
				_sig (use, tst);
			_list catCovList _atts use::divUse, tst::real
				_cat use::int
			 	_sig (use, tst);
			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list _key=foo divUse.covariate->covList, divUse.catCov->catCovList;
		'''.loadLibAndParse

		result.assertNoErrors(Diagnostic.SYNTAX_DIAGNOSTIC)
		result.assertError(MdlLibPackage.eINSTANCE.blockDefinition, MdlLibValidator::MALFORMED_BLOCK_DEFINITION,
							"Key 'foo' not found in mapped list definitions.")
	}

	@Ignore("Changed syntax so key is no longer needed if not mapped")
	def void testInvalidBlockKeyDefinitionMissingKeyNoMapping() {
		val result = '''
			_type divUse _enum (covariate, catCov);
			_list covList _alt Real _atts use::divUse, tst::real
				_sig (use, tst);
			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list covList;
		'''.loadLibAndParse

		result.assertNoErrors(Diagnostic.SYNTAX_DIAGNOSTIC)
		result.assertError(MdlLibPackage.eINSTANCE.blockDefinition, MdlLibValidator::MALFORMED_BLOCK_DEFINITION,
							"Key 'foo' not found in list definition.")
	}

	@Test 
	def void testBlockDeclnWithHasMalformedStatementDefn() {
		val result = '''
			_block DATA_INPUT_VARIABLES (0, 1) _arguments level::int, another::real? _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn+, _rvDefn;
		'''.loadLibAndParse

		result.assertError(MdlLibPackage::eINSTANCE.statementTypeDefn, MdlLibValidator::MALFORMED_STATEMENT_DEFINITION, "This statement type cannot use the '+' modifier.")
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