package eu.ddmore.mdllib.tests

import com.google.inject.Inject
import eu.ddmore.mdllib.MdlLibInjectorProvider
import eu.ddmore.mdllib.mdllib.Library
import eu.ddmore.mdllib.mdllib.MdlLibPackage
import eu.ddmore.mdllib.scoping.MdlLibLib
import eu.ddmore.mdllib.validation.MdlLibValidator
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import org.eclipse.xtext.diagnostics.Diagnostic

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
			_list covList _alt Real _atts use::divUse
				_sig (use);
			_list catCovList _atts use::divUse
				_cat use::Int
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
			_list covList _alt Real _atts use::divUse
				_sig (use);
			_list catCovList _atts use::divUse2
				_cat use::Int
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
			_list covList _alt Real _atts use::divUse, tst::Real
				_sig (use, tst);
			_list catCovList _atts use::divUse, tst::Real
				_cat use::Int
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
			_list covList _alt Real _atts use::divUse, tst::Real
				_sig (use, tst);
			_list catCovList _atts use::divUse, tst::Real
				_cat use::Int
			 	_sig (use, tst);
			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list _key=foo divUse.covariate->covList, divUse.catCov->catCovList;
		'''.loadLibAndParse

		result.assertNoErrors(Diagnostic.SYNTAX_DIAGNOSTIC)
		result.assertError(MdlLibPackage.eINSTANCE.blockDefinition, MdlLibValidator::MALFORMED_BLOCK_DEFINITION,
							"Key 'foo' not found in mapped list definitions.")
	}

	@Test 
	def void testInvalidBlockKeyDefinitionMissingKeyNoMapping() {
		val result = '''
			_type divUse _enum (covariate, catCov);
			_list covList _alt Real _atts use::divUse, tst::Real
				_sig (use, tst);
			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list _key=foo covList;
		'''.loadLibAndParse

		result.assertNoErrors(Diagnostic.SYNTAX_DIAGNOSTIC)
		result.assertError(MdlLibPackage.eINSTANCE.blockDefinition, MdlLibValidator::MALFORMED_BLOCK_DEFINITION,
							"Key 'foo' not found in list definition.")
	}

	@Test 
	def void testBlockDeclnWithHasMalformedStatementDefn() {
		val result = '''
			_block DATA_INPUT_VARIABLES (0, 1) _arguments level::Int, another::Real? _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn+, _rvDefn;
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