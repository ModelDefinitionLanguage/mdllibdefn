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
class TestBlockSyntax {
	
	@Inject extension MdlLibLib
	
	@Inject extension ParseHelper<Library>
	@Inject	extension ValidationTestHelper

	@Test 
	def void testBlockDeclnSyntax() {
		val result = '''
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testBlockDeclnWithArgDefnSyntax() {
		val result = '''
			_block DATA_INPUT_VARIABLES (0, 1) _arguments level::Int _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testBlockDeclnWith2ArgDefnSyntax() {
		val result = '''
			_block DATA_INPUT_VARIABLES (0, 1) _arguments level::Int, another::Real? _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn;
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
			_object dataObj;
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0,) _listDefn;
			_block MODEL_PREDICTION (0, ) _statements (0,) _eqnDefn, _eqnDefn+, _listDefn;						
			_block DEQ (0, ) _statements (0,) _eqnDefn, _eqnDefn+, _listDefn;
			_container dataObj _has DATA_INPUT_VARIABLES, MODEL_PREDICTION;
			_container MODEL_PREDICTION _has DEQ; 			
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