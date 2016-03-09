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
	def void testListDeclnSyntax() {
		val result = '''
			type VarLevel _list;
			list myList::VarLevel key=use
				atts use::Int , foo::Real
				sig (use, foo?);
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDecln2SigsSyntax() {
		val result = '''
			type VarLevel _list;
			list myList::VarLevel key=use
				atts use::Int , foo::Real, anot::String
				sig (use, foo?), (anot, foo?);
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