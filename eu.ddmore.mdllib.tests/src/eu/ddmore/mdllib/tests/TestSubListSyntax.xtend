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
class TestSubListSyntax {
	
	@Inject extension MdlLibLib
	
	@Inject extension ParseHelper<Library>
	@Inject	extension ValidationTestHelper

	@Test 
	def void testSubListDeclnWithSingleSigSyntax() {
		val result = '''
			_type testEnum _enum (foo, bar);
			_sublist aSubList _atts use::testEnum
				_sig (use);
			_list testList _atts use::testEnum, anAtt::aSubList
			 	_sig (use, anAtt?);
			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list _key=use testList;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testSubListDeclnWith2SigSyntax() {
		val result = '''
			_type testEnum _enum (foo, bar);
			_sublist aSubList _atts use::testEnum
				_sig (use);
			_list testList _atts use::testEnum, anAtt::aSubList, altAtt::Real
			 	_sig (use, anAtt?),
			 		 (use, altAtt);
			 				
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list _key=use testList;
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