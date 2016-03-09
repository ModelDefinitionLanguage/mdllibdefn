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
			block DATA_INPUT_VARIABLES (0, 1) statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testBlockDeclnWithArgDefnSyntax() {
		val result = '''
			block DATA_INPUT_VARIABLES (0, 1) arguments level::Int statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testBlockDeclnWith2ArgDefnSyntax() {
		val result = '''
			block DATA_INPUT_VARIABLES (0, 1) arguments level::Int, another::Real? statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testBlockDeclnMissingLimitsSyntax() {
		val result = '''
			block DATA_INPUT_VARIABLES (, ) statements (, ) _eqnDefn;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testObjectDeclnSyntax() {
		val result = '''
			object dataObj;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testObjectContentDefns() {
		val result = '''
			object dataObj;
			block DATA_INPUT_VARIABLES (0, 1) statements (0,) _listDefn;
			block MODEL_PREDICTION (0, ) statements (0,) _eqnDefn, _eqnDefn+, _listDefn;						
			block DEQ (0, ) statements (0,) _eqnDefn, _eqnDefn+, _listDefn;
			container dataObj has DATA_INPUT_VARIABLES, MODEL_PREDICTION;
			container MODEL_PREDICTION has DEQ; 			
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